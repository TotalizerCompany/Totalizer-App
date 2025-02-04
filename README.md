# Totalizer-App

O **Totalizer-App** é um aplicativo desenvolvido em Flutter com integração ao Firebase, projetado para ajudar os usuários a criar e gerenciar listas de compras. Ele permite a autenticação de usuários, o armazenamento de listas e recibos, e a exportação de listas para outro aplicativo. O aplicativo foi projetado para ser utilizado em dispositivos móveis, oferecendo uma experiência intuitiva e eficiente.

## Funcionalidades Principais

- **Autenticação de Usuários**: Utiliza o Firebase Authentication para permitir que os usuários se cadastrem e façam login no aplicativo.
- **Criação e Gerenciamento de Listas**: Permite que os usuários criem, editem e excluam listas de compras.
- **Armazenamento de Listas e Recibos**: Utiliza o Firebase Firestore para salvar listas e recibos de compras de forma segura e acessível.
- **Exportação de Listas**: Oferece a funcionalidade de exportar listas de compras para outro aplicativo, facilitando o compartilhamento e a integração com outras ferramentas.
- **Interface Intuitiva**: Desenvolvido com foco na usabilidade, o aplicativo possui uma interface simples e fácil de usar.

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento de aplicativos móveis multiplataforma, permitindo a criação de interfaces nativas para iOS e Android a partir de um único código base.
- **Firebase**: Plataforma de desenvolvimento de aplicativos que oferece diversos serviços, como autenticação, banco de dados em tempo real (Firestore) e armazenamento.
- **Firebase Authentication**: Para gerenciar o cadastro e login de usuários.
- **Firebase Firestore**: Para armazenar listas e recibos de compras de forma segura e escalável.

## Como Executar o Projeto

### Clone o Repositório:
```bash
git clone https://github.com/TotalizerCompany/Totalizer-App.git
```

### Navegue até o Diretório do Projeto:
```bash
cd Totalizer-App
```

### Instale as Dependências:
```bash
flutter pub get
```

### Configure o Firebase:
1. Crie um projeto no Firebase Console.
2. Adicione os arquivos de configuração do Firebase (`google-services.json` para Android e `GoogleService-Info.plist` para iOS) ao projeto.
3. Siga as instruções de configuração do Firebase para Flutter disponíveis na [documentação oficial](https://firebase.flutter.dev/docs/overview/).

### Execute o Aplicativo:
```bash
flutter run
```

## Estrutura do Projeto

```
Totalizer-App/
├── lib/
│   ├── main.dart  # Ponto de entrada do aplicativo
│   ├── models/  # Modelos de dados
│   ├── screens/  # Telas do aplicativo
│   ├── services/  # Lógica de negócio e integração com Firebase
│   ├── widgets/  # Componentes reutilizáveis
├── android/  # Configurações Android
├── ios/  # Configurações iOS
├── pubspec.yaml  # Configuração do projeto e dependências
```

## Contribuição

Contribuições são bem-vindas! Se você deseja contribuir para o projeto, siga os passos abaixo:

1. Faça um fork do repositório.
2. Crie uma branch para sua feature:
   ```bash
   git checkout -b feature/nova-feature
   ```
3. Commit suas mudanças:
   ```bash
   git commit -m 'Adicionando nova feature'
   ```
4. Envie para o repositório remoto:
   ```bash
   git push origin feature/nova-feature
   ```
5. Abra um Pull Request.

## Licença

Este projeto está licenciado sob a [licença MIT](LICENSE).

## Contato

Para mais informações, entre em contato com a equipe de desenvolvimento através do repositório do GitHub ou pelo email: **TotalizerCompany@gmail.com**.
