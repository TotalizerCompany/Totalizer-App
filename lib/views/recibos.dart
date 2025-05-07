import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totalizer_cell/services/firestore.dart';
import 'package:totalizer_cell/models/recibos.dart';
import 'package:intl/intl.dart';

class Recibos extends StatefulWidget {
  const Recibos({super.key});

  @override
  State<Recibos> createState() => _RecibosState();
}

class _RecibosState extends State<Recibos> {
  late FireStore _fireStore;
  String _selectedFilter = 'este_mes';
  double _currentMonthTotal = 0;
  double _lastMonthTotal = 0;

  @override
  void initState() {
    super.initState();
    _fireStore = FireStore();
  }

  Widget _buildFilterChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: Colors.blue.withOpacity(0.2),
      labelStyle: TextStyle(
        color: _selectedFilter == value ? Colors.blue : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildComparisonCard() {
    final difference = _lastMonthTotal - _currentMonthTotal;
    final isSavings = difference >= 0;
    final percentage = _lastMonthTotal > 0 
        ? (difference.abs() / _lastMonthTotal * 100).toStringAsFixed(1)
        : '100';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ANÁLISE MENSAL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Este mês', _currentMonthTotal),
                _buildStatItem('Mês passado', _lastMonthTotal),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSavings ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isSavings ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isSavings ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSavings
                        ? 'Economizou $percentage% (R\$ ${difference.toStringAsFixed(2)})'
                        : 'Gastou $percentage% a mais (R\$ ${difference.abs().toStringAsFixed(2)})',
                    style: TextStyle(
                      color: isSavings ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Este mês', 'este_mes'),
                const SizedBox(width: 8),
                _buildFilterChip('Mês anterior', 'mes_anterior'),
                const SizedBox(width: 8),
                _buildFilterChip('Comparar meses', 'comparacao'),
              ],
            ),
          ),
        ),
        if (_selectedFilter == 'comparacao') _buildComparisonCard(),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _fireStore.conectarStreamRecibos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhum recibo encontrado'));
              }

              // Processa todos os recibos
              final allRecibos = snapshot.data!.docs.map((doc) {
                return ReciboModelo.fromMap(doc.data());
              }).toList();

              // Calcula totais
              _currentMonthTotal = allRecibos
                  .where((recibo) => recibo.timestamp.isAfter(currentMonthStart))
                  .fold(0.0, (sum, recibo) => sum + recibo.total);

              _lastMonthTotal = allRecibos
                  .where((recibo) => 
                      recibo.timestamp.isAfter(lastMonthStart) &&
                      recibo.timestamp.isBefore(currentMonthStart))
                  .fold(0.0, (sum, recibo) => sum + recibo.total);

              // Filtra conforme seleção
              List<ReciboModelo> filteredRecibos = [];
              switch (_selectedFilter) {
                case 'este_mes':
                  filteredRecibos = allRecibos
                      .where((recibo) => recibo.timestamp.isAfter(currentMonthStart))
                      .toList();
                  break;
                case 'mes_anterior':
                  filteredRecibos = allRecibos
                      .where((recibo) => 
                          recibo.timestamp.isAfter(lastMonthStart) &&
                          recibo.timestamp.isBefore(currentMonthStart))
                      .toList();
                  break;
                default:
                  filteredRecibos = allRecibos;
              }

              if (filteredRecibos.isEmpty) {
                return Center(child: Text(
                  'Nenhum recibo em ${_selectedFilter == 'este_mes' ? 'este mês' : 'mês anterior'}'));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: filteredRecibos.length,
                itemBuilder: (context, index) {
                  final recibo = filteredRecibos[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          shape: BoxShape.circle),
                        child: const Icon(Icons.receipt, size: 20),
                      ),
                      title: Text(
                        DateFormat('dd/MM/yyyy').format(recibo.timestamp),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '${recibo.itens.length} ${recibo.itens.length == 1 ? 'item' : 'itens'}'),
                      trailing: Text(
                        'R\$ ${recibo.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}