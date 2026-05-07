# Template Padrão PBI - Análises Financeiras

Template reutilizável para criação de relatórios Power BI com foco em análises financeiras. Estruturado de forma modular para ser facilmente adaptável a diferentes projetos.

## 📋 Estrutura do Template

```
pbi-template-padrao/
├── .pbiproject.json                    # Arquivo raiz do projeto
├── Template-Financeiro.Report/
│   ├── definition.json                 # Definição de páginas e visuais
│   ├── measures.dax                    # Medidas DAX pré-configuradas
│   └── data-model.json                 # Estrutura do modelo de dados
├── README.md                           # Este arquivo
└── GUIA_DE_USO.md                      # Guia prático de implementação
```

## 🎯 Características Principais

### ✅ 4 Páginas Pré-Configuradas

1. **Dashboard Executivo** - Visão geral com KPIs principais
   - Receita Total, Despesas Totais, Lucro Líquido
   - Gráficos de tendência e decomposição
   - Tabela de resumo por departamento

2. **Detalhes de Receita** - Análise granular de receitas
   - Receita por fonte
   - Timeline de receita
   - Tabela detalhada com YoY Growth

3. **Detalhes de Despesas** - Análise de despesas
   - Despesas por categoria
   - Variação vs Orçamento (Waterfall)
   - Tabela com análise de variância

4. **Análises Avançadas** - Comparativas e tendências
   - Análise Ano a Ano (YoY)
   - Análise de Variância
   - Matriz de análise multidimensional

### 📊 Visuais Padrão

- **KPIs**: Receita, Despesas, Lucro
- **Gráficos de Linha**: Tendências ao longo do tempo
- **Gráficos de Coluna**: Comparações categoriais
- **Gráficos de Rosca**: Decomposição de valores
- **Tabelas**: Detalhes transacionais
- **Matriz**: Análises multidimensionais

### 🎨 Filtros Padrão

- **Período**: Filtro de data (permite seleção de range)
- **Departamento**: Dropdown para seleção de departamentos
- **Centro de Custo**: Filtro por centro de custo
- **Fonte de Receita**: Filtro específico para receitas
- **Categoria de Despesa**: Filtro por tipo de despesa

### 📐 Medidas DAX Pré-Configuradas

#### Receita
- `Total Revenue` - Soma total de receita
- `Revenue YTD` - Receita acumulada no ano
- `Revenue MTD` - Receita do mês
- `Revenue YoY Growth %` - Crescimento ano a ano
- `Revenue by Department` - Receita por departamento

#### Despesas
- `Total Expenses` - Soma total de despesas
- `Expenses YTD` - Despesas acumuladas no ano
- `Expenses YoY Growth %` - Crescimento de despesas
- `Expenses vs Budget %` - Variação orçamentária

#### Lucratividade
- `Net Profit` - Lucro líquido
- `Net Profit Margin %` - Margem de lucro
- `EBITDA` - Lucro operacional
- `ROI %` - Retorno sobre investimento

#### Indicadores de Status
- `Budget Status` - "Over Budget", "On Target", "Under Budget"
- `Revenue Status` - "Growing", "Stable", "Declining"
- `Profit Status` - "Excellent", "Good", "Fair", "Negative"

## 🗂️ Modelo de Dados

### Tabelas de Dimensão

**DimDate**
- Tabela de datas com atributos: ano, mês, trimestre, dia da semana

**DimDepartment**
- Departamentos com gerente, centro de custo e divisão

**DimExpenseCategory**
- Categorias de despesa (fixa/variável)

**DimRevenueSource**
- Fontes de receita por região e canal

### Tabelas de Fato

**FactRevenue**
- Transações de receita com quantidade e preço unitário

**FactExpenses**
- Transações de despesa com descrição

**FactBudget**
- Orçamento planejado por período e categoria

## 🚀 Como Usar Este Template

### Passo 1: Preparar os Dados
1. Exporte seus dados financeiros em formato CSV/Excel
2. Prepare as tabelas conforme a estrutura do modelo de dados:
   - FactRevenue
   - FactExpenses
   - FactBudget
   - DimDate (crie uma tabela de datas)
   - DimDepartment
   - DimExpenseCategory
   - DimRevenueSource

### Passo 2: Criar o Projeto
1. Abra Power BI Desktop
2. Crie um novo projeto em formato `.pbip`
3. Copie a estrutura deste template
4. Importe as suas tabelas de dados

### Passo 3: Ajustar Nomes e Campos
1. Atualize os nomes das colunas nas medidas DAX conforme seus dados
2. Adapte os filtros para seus campos específicos
3. Atualize as relações do modelo se necessário

### Passo 4: Personalizar Visuais
1. Ajuste cores conforme paleta da sua empresa
2. Adapte os nomes das páginas
3. Modifique os títulos dos gráficos
4. Reposicione visuais conforme preferência

### Passo 5: Testar e Publicar
1. Teste todos os filtros e interações
2. Valide os cálculos DAX
3. Publique no Power BI Service
4. Configure compartilhamento e permissões

## 🎨 Paleta de Cores Padrão

```json
{
  "primary": "#0066CC",     // Azul
  "secondary": "#00B050",   // Verde
  "accent": "#FF6B6B",      // Vermelho coral
  "neutral": "#808080",     // Cinza
  "warning": "#FFC000",     // Laranja
  "success": "#00B050",     // Verde
  "error": "#FF0000"        // Vermelho
}
```

## 📝 Personalizações Comuns

### Adicionar Nova Fonte de Receita
1. Adicione registros em `DimRevenueSource`
2. Crie medida: `Revenue [Nome Fonte] = CALCULATE([Total Revenue], DimRevenueSource[Source] = "[Nome]")`
3. Adicione visual na página de Detalhes de Receita

### Adicionar Nova Categoria de Despesa
1. Adicione registros em `DimExpenseCategory`
2. O filtro é automático (usa UNIQUEVALUE)
3. Ajuste medidas se precisar de lógica especial

### Criar Análise por Região
1. Adicione coluna `Region` em `DimRevenueSource` ou `DimDepartment`
2. Crie medida: `Revenue by Region = SUMIF(DimRevenueSource[Region], ...)`
3. Adicione visual com região como dimensão

### Adicionar Previsão
1. Crie tabela `FactForecast` com estrutura similar a `FactRevenue`
2. Crie medida: `Forecast Revenue = SUMX(FactForecast, ...)`
3. Combine em visual: `[Total Revenue]` vs `[Forecast Revenue]`

## 🔧 Configurações Recomendadas

### Formato de Números
- Moeda: R$ 1.234,56
- Percentual: 12,34%
- Números: 1.234

### Configuração de Fonte
- Título: Segoe UI, 18pt, Bold
- Subtítulo: Segoe UI, 14pt, Regular
- Corpo: Segoe UI, 12pt, Regular

### Configuração de Filtros
- Mostrar todos os filtros no topo
- Permitir seleção múltipla
- Filtros aplicáveis em todas as páginas

## 📚 Referências e Recursos

- [DAX Function Reference](https://docs.microsoft.com/en-us/dax/dax-function-reference)
- [Power BI Best Practices](https://docs.microsoft.com/en-us/power-bi/guidance/)
- [Data Modeling Guide](https://docs.microsoft.com/en-us/power-bi/guidance/star-schema)

## ✏️ Changelog

### v1.0.0 (2026-05-07)
- Template inicial criado
- 4 páginas pré-configuradas
- 40+ medidas DAX
- Modelo de dados padrão
- Documentação completa

## 👤 Autor
Alice Grazi

## 📄 Licença
Este template é reutilizável e adaptável para múltiplos projetos.

---

**Próximo passo?** Consulte [GUIA_DE_USO.md](./GUIA_DE_USO.md) para um passo-a-passo prático!
