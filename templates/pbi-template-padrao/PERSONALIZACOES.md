# 🎨 Guia de Personalizações Comuns

Exemplos práticos de como adaptar o template para diferentes casos de uso.

---

## 📊 Cenário 1: Análise de Vendas

### Ajustes Necessários

**Dimensões a Adicionar:**
- Produto/SKU
- Gerente de Vendas
- Cliente/Segmento
- Região

**Medidas a Adicionar:**

```dax
// Quantidade de Vendas
Units Sold = SUM(FactSales[Quantity])

// Ticket Médio
Average Ticket = [Total Revenue] / [Units Sold]

// Taxa de Conversão
Conversion Rate = [Units Sold] / [Visitors]

// Análise ABC (Pareto)
ABC Classification =
    VAR Rank = RANK(
        ALL(DimProduct[Product]),
        [Total Revenue],
        DESC)
    VAR Total = COUNTROWS(DimProduct)
    VAR Cumulative = 
        CALCULATE(
            COUNTROWS(DimProduct),
            FILTER(ALL(DimProduct), 
                RANK(ALL(DimProduct), [Total Revenue], DESC) <= RANK(ALL(DimProduct), [Total Revenue], DESC)))
    VAR CumulativePercent = Cumulative / Total
    RETURN
        IF(CumulativePercent <= 0.8, "A",
           IF(CumulativePercent <= 0.95, "B", "C"))
```

### Páginas Sugeridas

1. Dashboard: Top 10 Produtos
2. Análise Regional
3. Vendedor Performance
4. Funil de Vendas
5. Análise ABC

---

## 💰 Cenário 2: Análise de Fluxo de Caixa

### Ajustes Necessários

**Medidas de Fluxo:**

```dax
// Saldo Inicial
Beginning Balance = [Previous Balance]

// Entradas
Cash Inflow = [Received Payments] + [Other Income]

// Saídas
Cash Outflow = [Paid Expenses] + [Investments]

// Saldo Final
Ending Balance = [Beginning Balance] + [Cash Inflow] - [Cash Outflow]

// Saldo Diário Cumulativo
Cumulative Daily Balance =
    CALCULATE(
        [Ending Balance],
        FILTER(ALL(DimDate), DimDate[DateKey] <= MAX(DimDate[DateKey])))

// Dias de Caixa
Days of Cash = [Ending Balance] / [Average Daily Burn]

// Previsão de Caixa (próximos 30 dias)
Cash Forecast 30Days = [Ending Balance] + (30 * [Average Daily Inflow]) - (30 * [Average Daily Outflow])
```

### Visuais Especiais

- **Waterfall**: Fluxo diário de caixa
- **Line Chart**: Saldo cumulativo ao longo do tempo
- **Card**: Saldo atual, previsão 30d
- **Matrix**: Inflow vs Outflow por departamento

### Páginas Sugeridas

1. Dashboard: Saldo Atual
2. Fluxo Diário
3. Previsões
4. Análise por Departamento
5. Sazonalidade

---

## 📈 Cenário 3: Análise de Margens e Lucratividade

### Ajustes Necessários

**Dimensões:**
- Linha de Produto
- Segmento de Cliente
- Custo por Produto

**Medidas:**

```dax
// Custo de Produção
Product Cost = SUMX(FactCosts, FactCosts[Cost])

// Lucro Bruto Detalhado
Gross Profit by Product = [Revenue] - [Product Cost]

// Margem Bruta %
Gross Margin % = [Gross Profit] / [Revenue]

// Ponto de Equilibrio
Breakeven Point = [Fixed Costs] / [Contribution Margin %]

// Análise de Sensibilidade
Sensitivity - 10% Price = ([Revenue] * 0.9) - [Total Expenses]

Sensitivity + 10% Volume = ([Revenue] * 1.1) - [Total Expenses]

// Margem de Contribuição
Contribution Margin = [Revenue] - [Variable Costs]

Contribution Margin % = [Contribution Margin] / [Revenue]
```

### Visuais Especiais

- **Scatter**: Margem vs Volume
- **Heatmap**: Rentabilidade por produto/região
- **Ribbon Chart**: Top produtos por margem
- **Matrix**: Análise sensibilidade

### Páginas Sugeridas

1. Dashboard Margens
2. Análise por Produto
3. Análise Sensibilidade
4. Comparativo Benchmark
5. Tendência de Margens

---

## 🏭 Cenário 4: Análise Operacional/Custos

### Ajustes Necessários

**Dimensões:**
- Centro de Custo
- Tipo de Custo (Fixo/Variável)
- Projeto/Atividade
- Responsável

**Medidas:**

```dax
// Custos Fixos
Fixed Costs = SUMX(
    FILTER(FactExpenses, FactExpenses[Type] = "Fixed"),
    FactExpenses[Amount])

// Custos Variáveis
Variable Costs = SUMX(
    FILTER(FactExpenses, FactExpenses[Type] = "Variable"),
    FactExpenses[Amount])

// Custo Unitário
Cost per Unit = [Total Costs] / [Units Produced]

// Análise de Variância de Custo
Cost Variance = [Budget Costs] - [Actual Costs]

Cost Variance % = [Cost Variance] / [Budget Costs]

// Índice de Eficiência
Efficiency Index = [Budget Costs] / [Actual Costs]

// Custo Incremental
Incremental Cost = ([Total Costs] - [Previous Costs]) / ([Volume] - [Previous Volume])
```

### Dashboard Recomendado

1. KPI: Índice de Eficiência
2. Custo por Centro
3. Variância Orçamentária
4. Custo Fixo vs Variável
5. Tendência de Eficiência

---

## 🎯 Cenário 5: Análise de Departamentos/Centros de Custo

### Estrutura Recomendada

**Dimensão Adicional:**
- Centro de Custo (hierarquia)
- Responsável
- Orçamento Aprovado

**Medidas de Departamento:**

```dax
// Receita por Depto
Dept Revenue = SUMIFS(FactRevenue[Amount], 
    DimDepartment[Department], SELECTEDVALUE(DimDepartment[Department]))

// Despesa por Depto
Dept Expenses = SUMIFS(FactExpenses[Amount],
    DimDepartment[Department], SELECTEDVALUE(DimDepartment[Department]))

// Margem por Depto
Dept Margin % = ([Dept Revenue] - [Dept Expenses]) / [Dept Revenue]

// Performance vs Orçamento
Dept Budget Variance = [Dept Expenses] - [Dept Budget]

// Ranking de Departamentos
Dept Ranking = RANK(ALL(DimDepartment), [Dept Revenue], DESC)
```

### Página: Performance de Departamentos

```
┌─────────────────────────────────────────────┐
│ Seletor: Departamento                       │
├─────────────────────────────────────────────┤
│ KPI: Revenue    KPI: Expenses    KPI: Margin│
├─────────────────────────────────────────────┤
│  Bar Chart: Benchmark vs Orçamento          │
├─────────────────────────────────────────────┤
│  Table: Detalhes de Transações              │
└─────────────────────────────────────────────┘
```

---

## 📱 Cenário 6: Dashboard para Mobile

### Ajustes:

1. **Reduzir número de visuais por página** (máx 3)
2. **Aumentar tamanho de cards**
3. **Usar filtros em Dropdown** (não Slicer)
4. **Números grandes e legíveis**
5. **Cores de alto contraste**

```dax
// Medida simples para mobile
Revenue Card = [Total Revenue]

Margin Card = [Net Profit Margin %]

Growth Card = [Revenue YoY Growth %]
```

### Exemplo de Layout Mobile

```
Página 1: KPIs
- 1 grande card: Receita Hoje
- 1 grande card: Meta vs Realizado
- 1 gráfico: Tendência 7 dias

Página 2: Departamentos
- Dropdown: Selecionar Depto
- Card: Revenue Depto
- Card: Margem Depto
- Gráfico: Comparativo

Página 3: Alertas
- Cards para KPIs em Risco
- Exceções de orçamento
- Top vendedores
```

---

## 🔗 Como Adaptar o Template

### Passo 1: Identificar Necessidade
- Qual é o objetivo principal?
- Quem são os usuários?
- Que dados temos disponíveis?

### Passo 2: Redesenhar Modelo
- Adicionar/remover dimensões
- Criar novo relacionamentos
- Planificar medidas novas

### Passo 3: Implementar Medidas
```dax
Copiar template base → Adaptar nomes → Testar valores → Validar com origem
```

### Passo 4: Criar Páginas
```
Layout → Adicionar visuais → Conectar dados → Formatar → Testar interações
```

### Passo 5: Validar e Deploy
```
Teste completo → Feedback usuários → Ajustes → Publicação → Treinamento
```

---

## 💡 Dicas de Customização

1. **Sempre manter o core intacto**: Dimensões e fatos básicas reutilizáveis
2. **Versionamento**: Crie versão 1.1, 1.2 quando adicionar features
3. **Documentação**: Atualize README com customizações
4. **Performance**: Teste com volume real de dados
5. **Backup**: Salve versão anterior antes de grandes mudanças

---

## 📚 Template por Indústria

### Varejo
- Análise de Categoria/SKU
- Margens por Loja
- Análise de Estoque
- Sazonalidade

### Manufatura
- Custo de Produção
- Análise de Eficiência
- Análise de Rejeição
- Capacidade

### Serviços
- Análise por Projeto
- Utilização de Recursos
- Rentabilidade de Cliente
- Análise de Tempo

### Financeiro (seu caso!)
- Análise de Riscos
- Conformidade Regulatória
- Análise de Portfólio
- Previsão de Fluxo

---

**Pronto para customizar?** Comece pelo cenário mais próximo do seu caso e incremente! 🚀
