# VlintUI
```mermaid
graph TD
    A[Source Code] --> B[Wally]
    B --> C[Dependencies]
    C --> D[Darklua]
    D --> E[dist/library.lua]
    E --> F[loadstring()]
```