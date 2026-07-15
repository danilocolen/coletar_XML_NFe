# Coletor de XML de NF-e por Mês/Ano

## Descrição

Script desenvolvido em PowerShell para automatizar a separação de arquivos XML de NF-e com base na data de emissão da nota fiscal (`<dhEmi>`), eliminando a necessidade de filtragem pela data de modificação do arquivo.

O projeto foi criado para solucionar um problema ocorrido durante a coleta retroativa de XMLs, onde todos os arquivos receberam a mesma data de modificação, impossibilitando a separação das notas pelo mês desejado utilizando apenas o Explorador de Arquivos do Windows.

---

## Problema

Durante a coleta retroativa dos XML de NF-e, todos os arquivos passaram a possuir a mesma data de modificação (14/07/2026).

Com isso não era mais possível identificar quais notas pertenciam ao mês de junho apenas pela data do arquivo.

As alternativas seriam:

- Abrir manualmente cada XML para verificar sua data de emissão;
- Ou acessar o sistema emissor (Espião de NF) e realizar o download individual de mais de 100 notas fiscais.

Além do tempo elevado, o processo estava sujeito a erros operacionais.

---

## Solução

Foi desenvolvido um script em PowerShell que percorre todos os arquivos XML de uma pasta, lê a data de emissão diretamente do conteúdo da nota fiscal (`<dhEmi>`), filtra pelo mês e ano informados e copia apenas os arquivos correspondentes para uma nova pasta.

O script também gera um relatório contendo todas as notas copiadas.

---

## Funcionalidades

- Solicita ao usuário:
  - Pasta de origem
  - Pasta de destino
  - Mês
  - Ano

- Percorre todos os XML da pasta de origem

- Lê automaticamente a tag:

```xml
<dhEmi>
```

- Funciona com XML de NF-e que utilizam namespace XML

- Filtra apenas os arquivos do mês e ano informados

- Copia somente os XML correspondentes

- Exibe barra de progresso durante o processamento

- Mostra:

  - Total de arquivos encontrados
  - Arquivos processados
  - Arquivos copiados
  - Quantidade de erros
  - Tempo total de execução

- Gera um arquivo:

```
Relatorio.txt
```

contendo:

- Data da emissão
- Chave da NF-e (quando disponível)
- Nome do arquivo

---

## Benefícios

- Elimina trabalho manual
- Reduz erros de seleção de arquivos
- Reutilizável para qualquer mês e ano
- Não depende da data de modificação do arquivo
- Automatiza um processo recorrente

O que poderia levar cerca de **1 hora de trabalho manual** passou a ser realizado em **poucos segundos**.

---

## Pré-requisitos

- Windows PowerShell 5.1 ou superior
- Permissão de leitura na pasta de origem
- Permissão de gravação na pasta de destino

---

## Como executar

Salvar o script com extensão:

```
.ps1
```

Exemplo:

```
Coletar_XML_NFe.ps1
```

Executar pelo PowerShell:

```powershell
.\Coletar_XML_NFe.ps1
```

Caso a política de execução esteja bloqueando scripts:

```powershell
Set-ExecutionPolicy RemoteSigned
```

ou

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Coletar_XML_NFe.ps1
```

---

## Exemplo de utilização

Origem:

```
\\SERVERDFS1\NFe
```

Destino:

```
\\SERVERDFS1\NFe\NFS-e - Junho_2026
```

Mês:

```
6
```

Ano:

```
2026
```

---

## Fluxo de execução

```text
Início
   │
   ▼
Solicita Origem, Destino, Mês e Ano
   │
   ▼
Lista todos os XML
   │
   ▼
Lê a tag <dhEmi>
   │
   ▼
Converte para Data
   │
   ▼
Mês/Ano correspondem?
   │
 ┌───────┴────────┐
 │                │
Sim              Não
 │                │
 ▼                ▼
Copia XML      Próximo arquivo
 │
 ▼
Registra no relatório
 │
 ▼
Exibe estatísticas
 │
 ▼
Fim
```

---

## Estrutura utilizada

O script utiliza a data de emissão existente no XML da NF-e:

```xml
<ide>
    <dhEmi>2026-06-15T10:32:45-03:00</dhEmi>
</ide>
```

Essa abordagem garante que a filtragem seja realizada utilizando a informação oficial da nota fiscal, independentemente da data de modificação do arquivo.

---

## Tecnologias

- PowerShell
- XML Parser (.NET)
- Windows PowerShell
- Sistema de Arquivos Windows

---

## Melhorias futuras

- Exportação para CSV
- Interface gráfica (Windows Forms)
- Seleção por intervalo de datas
- Geração de logs detalhados
- Processamento paralelo para grandes volumes de XML
- Empacotamento em executável (.exe)

---

## Licença

Projeto desenvolvido para automação de processos internos de coleta e organização de arquivos XML de NF-e.
