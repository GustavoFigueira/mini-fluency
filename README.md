# Mini Fluency

Aplicativo de trilha de aprendizado de inglês desenvolvido para a Fluency Academy.

## 🌐 Preview Online

Acesse a versão online: [👉💻 Site](https://mini-fluency.web.app/)

## Requisitos

- Flutter 3.38.7 ou superior
- Dart SDK 3.5.4 ou superior

## Instalação

1. Clone o repositório
2. Execute `flutter pub get`
3. Execute `flutter pub run build_runner build --delete-conflicting-outputs`
4. Execute `flutter run` ou use os botões de execução do VSCode/Cursor com o `launch.json` configurado

## Funcionalidades

- Trilha visual com nós representando lições
- Estados: concluída (check verde), atual (brilho animado), bloqueada (cadeado)
- Lista de tarefas por lição com toggle de conclusão
- Indicador de progresso
- Animações e transições suaves
- Tema escuro/claro com inversão automática do modal
- Cache local do progresso - o app salva automaticamente quais tarefas e módulos foram concluídos, permitindo que o usuário retome de onde parou ao reabrir o app
- Trilha sonora de fundo (sem direitos autorais, similar ao app Fluency)
- Efeitos sonoros para feedback de ações (completar tarefa, finalizar lição)

## Arquitetura

```
lib/
├── core/
│   ├── core.dart                  # Barrel export
│   ├── design_system/
│   │   ├── design_system.dart     # Barrel export
│   │   ├── colors.dart
│   │   ├── spacing.dart
│   │   └── typography.dart
│   ├── services/
│   │   ├── services.dart         # Barrel export
│   │   └── audio_service.dart     # Audio management
│   └── utils/
│       ├── utils.dart             # Barrel export
│       └── time_formatter.dart
├── models/
│   ├── models.dart                # Barrel export
│   ├── path_model.dart
│   ├── lesson_model.dart
│   └── task_model.dart
├── data/
│   ├── data.dart                  # Barrel export
│   ├── repositories/
│   │   ├── repositories.dart      # Barrel export
│   │   └── path_repository.dart
│   └── providers/
│       ├── providers.dart         # Barrel export
│       └── path_provider.dart
├── screens/
│   ├── screens.dart               # Barrel export
│   ├── path_screen.dart
│   └── tasks_screen.dart
├── widgets/
│   ├── widgets.dart               # Barrel export
│   └── ...
└── main.dart
```

## Padrões Utilizados

- **Barrel Exports**: Cada pasta possui um arquivo de export para imports limpos
- **Freezed**: Models imutáveis com copyWith, equality e JSON serialization
- **Provider**: Gerenciamento de estado com ChangeNotifier
- **Design System**: Tokens centralizados (colors, typography, spacing)
- **Clean Architecture**: Separação em camadas (data, models, screens, widgets)

## Geração de Código

Para regenerar models após alterações:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Observações

### Código em Inglês

Código e documentação técnica em inglês para padronização.

### Uso de IA

Utilizei o Cursor como auxílio para acelerar o desenvolvimento. Parte do código foi gerada com IA, porém todo o projeto foi refinado manualmente, com atenção especial nas telas e arquitetura, utilizando minha com usabilidade e experiência do usuário.

### Cache Local do Progresso

O aplicativo salva automaticamente o progresso localmente usando `SharedPreferences`, permitindo que o usuário retome de onde parou ao reabrir o app.

### Trilha Sonora

O aplicativo inclui uma trilha sonora de fundo sem direitos autorais, similar ao app Fluency, com efeitos sonoros para feedback de ações.

### Customização Nativa

O aplicativo possui customizações nativas para o launcher icon e splash screen, utilizando os assets oficiais da [Fluency Academy](https://fluency.io/br/). A splash screen utiliza o logo Mini Fluency, enquanto o launcher icon utiliza o ícone oficial.

### Testes

O projeto possui testes unitários e de widget cobrindo as funcionalidades principais:

- Testes de acessibilidade de lições (bloqueadas/desbloqueadas)
- Testes de finalização de tasks e lições completas
- Testes de componentes visuais principais

Para executar os testes:

```bash
flutter test
```

Mais detalhes sobre o projeto podem ser encontrados no [repositório GitHub](https://github.com/GustavoFigueira/mini-fluency).

## Tempo de Desenvolvimento

Aproximadamente 6 horas
