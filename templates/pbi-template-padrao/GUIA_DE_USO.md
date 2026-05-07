# 📖 Guia Prático de Uso - Template PBI

Passo-a-passo para implementar este template em seu novo projeto Power BI.

## 🎯 Objetivo Final

Criar um relatório financeiro completo em ~30 minutos, reutilizando 80% da estrutura do template.

---

## 📋 Checklist Inicial

- [ ] Dados preparados em Excel/CSV
- [ ] Power BI Desktop instalado (versão 2024+)
- [ ] Estrutura do template baixada
- [ ] Tempo disponível: 2-3 horas para primeira implementação

---

## ⚡ Guia Rápido (5 minutos)

Se você já tem os dados prontos:

1. **Crie um novo projeto .pbip** no Power BI Desktop
2. **Importe dados** nas tabelas: FactRevenue, FactExpenses, FactBudget, Dim*
3. **Copie as medidas DAX** do arquivo `measures.dax`
4. **Recrie as páginas** seguindo `definition.json`
5. **Publique** no Power BI Service

---

## 📊 Guia Detalhado Passo-a-Passo

### FASE 1: PREPARAÇÃO DE DADOS (15 min)

#### 1.1 Estruturar Dados de Receita

Seu arquivo Excel deve ter estas colunas:

```
Data        | Departamento | Fonte         | Quantidade | Valor Unitário | Valor Total
2026-01-15  | Vendas       | Produto A     | 100        | 50.00         | 5000.00
2026-01-16  | Vendas       | Produto B     | 50         | 100.00        | 5000.00
```

**Transformar em:**

```
DateKey (YYYYMMDD) | DepartmentID | SourceID | Quantity | UnitPrice | Amount
20260115           | 1            | 1        | 100      | 50.00     | 5000.00
20260116           | 1            | 2        | 50       | 100.00    | 5000.00
```

#### 1.2 Estruturar Dados de Despesas

```
Data       | Departamento | Categoria    | Valor      | Descrição
2026-01-10 | Vendas       | Salários     | 15000.00   | Folha de pagamento
2026-01-10 | Vendas       | Aluguel      | 5000.00    | Aluguel escritório
```

**Transformar em:**

```
DateKey | DepartmentID | CategoryID | Amount    | Description
202601  | 1            | 1          | 15000.00  | Folha de pagamento
202601  | 1            | 2          | 5000.00   | Aluguel escritório
```

#### 1.3 Tabelas de Dimensão

**DimDepartment:**
```
DepartmentID | Department  | Manager    | CostCenter | Division
1            | Vendas      | João Silva | CC-001     | Comercial
2            | Operações   | Maria OS   | CC-002     | Operacional
```

**DimExpenseCategory:**
```
CategoryID | Category | Subcategory | ExpenseType
1          | Salários | Direto      | Fixed
2          | Aluguel  | Imóvel      | Fixed
3          | Material | Consumo     | Variable
```

**DimRevenueSource:**
```
SourceID | Source      | Region    | Channel
1        | Produto A   | SP        | Online
2        | Produto B   | SP        | Offline
```

**DimDate:**
```
DateKey | Date       | Year | Month | MonthName | Quarter | DayOfWeek | DayName | IsWeekend
20260101| 2026-01-01 | 2026 | 1     | Janeiro   | Q1      | 5         | Quinta  | False
```

---

### FASE 2: CRIAR PROJETO NO POWER BI (10 min)

#### 2.1 Criar Novo Projeto .pbip

1. **Power BI Desktop → File → New**
2. **File → Save As → Salve como .pbip format**
3. Nome sugerido: `MeuProjeto-Financeiro.pbip`

#### 2.2 Importar Dados

1. **Home → Get Data → Excel**
2. Carregue seu arquivo com as tabelas
3. Para cada tabela:
   - Click **Transform Data**
   - Verifique tipos de dados
   - Renomeie colunas se necessário
   - Click **Close & Apply**

#### 2.3 Criar Tabela de Data

Se não tiver tabela de datas:

```
New Table = CALENDAR(DATE(2025,1,1), DATE(2026,12,31))
```

Depois adicione colunas calculadas:
- Year: `YEAR([Date])`
- Month: `MONTH([Date])`
- MonthName: `FORMAT([Date], "mmmm", "pt-BR")`
- Quarter: `"Q"&ROUNDUP(MONTH([Date])/3, 0)`

---

### FASE 3: CRIAR RELACIONAMENTOS (10 min)

#### 3.1 Configurar Relacionamentos

1. **Model → Manage Relationships**
2. Crie os relacionamentos conforme `data-model.json`:

| Tabela Origem | Coluna Origem | Tabela Destino | Coluna Destino | Tipo | Ativo |
|---|---|---|---|---|---|
| FactRevenue | DateKey | DimDate | DateKey | M:1 | ✓ |
| FactRevenue | DepartmentID | DimDepartment | DepartmentID | M:1 | ✓ |
| FactRevenue | SourceID | DimRevenueSource | SourceID | M:1 | ✓ |
| FactExpenses | DateKey | DimDate | DateKey | M:1 | ✓ |
| FactExpenses | DepartmentID | DimDepartment | DepartmentID | M:1 | ✓ |
| FactExpenses | CategoryID | DimExpenseCategory | CategoryID | M:1 | ✓ |

---

### FASE 4: CRIAR MEDIDAS DAX (15 min)

#### 4.1 Copiar Medidas

1. **Model → New Measure**
2. Copie cada medida do arquivo `measures.dax`
3. Ajuste os nomes de tabelas conforme seus dados

**Exemplo - Medida de Receita:**

```dax
Total Revenue = SUMX(FactRevenue, FactRevenue[Amount])
```

Se sua tabela se chama `Revenue`:
```dax
Total Revenue = SUMX(Revenue, Revenue[Amount])
```

#### 4.2 Principais Medidas a Copiar (mínimo)

- `Total Revenue`
- `Total Expenses`
- `Net Profit`
- `Revenue YoY Growth %`
- `Expenses YoY Growth %`
- `Net Profit Margin %`

---

### FASE 5: CRIAR PÁGINAS E VISUAIS (45 min)

#### 5.1 Página 1: Dashboard Executivo

1. **Insert → New Page**
2. Nomeie: "Dashboard Executivo"
3. Adicione visuais conforme `definition.json`:

**KPI 1: Receita Total**
- Visualização: Card
- Value: Total Revenue
- Formato: Moeda
- Cores: Verde para positivo

**KPI 2: Despesas**
- Visualização: Card
- Value: Total Expenses
- Formato: Moeda

**KPI 3: Lucro**
- Visualização: Card
- Value: Net Profit
- Cores: Vermelho se negativo

**Gráfico 1: Receita por Período**
- Visualização: Line Chart
- Eixo X: DimDate[MonthName]
- Eixo Y: Total Revenue
- Legenda: DimDepartment[Department]

**Gráfico 2: Despesas por Categoria**
- Visualização: Donut Chart
- Legend: DimExpenseCategory[Category]
- Values: Total Expenses

**Tabela: Resumo por Departamento**
- Colunas: Department, Total Revenue, Total Expenses, Net Profit
- Classificação: Total Revenue decrescente

#### 5.2 Página 2: Detalhes de Receita

1. Insira: **Slicer** de Período (DimDate[MonthName])
2. **Line Chart**: Evolução de Receita ao Longo do Tempo
3. **Bar Chart**: Receita por Fonte
4. **Table**: Detalhes com todas as transações

#### 5.3 Página 3: Detalhes de Despesas

Similar à página anterior, mas com:
- **Waterfall Chart**: Variação vs Orçamento
- **Bar Chart**: Despesas por Categoria
- **Table**: Detalhes de despesas

#### 5.4 Página 4: Análises Avançadas

1. **Matrix Visual**: 
   - Linhas: Department, ExpenseCategory
   - Colunas: Month
   - Valores: Total Revenue, Total Expenses, Profit Margin %

2. **Scatter Chart**:
   - X Axis: Total Revenue
   - Y Axis: Profit Margin %
   - Legend: Department

---

### FASE 6: CONFIGURAR FILTROS (10 min)

#### 6.1 Adicionar Slicers (Filtros)

1. **Insert → Slicer**
2. Selecione campo a filtrar

**Slicer 1: Período**
- Campo: DimDate[Date]
- Tipo: Between
- Coloque no topo

**Slicer 2: Departamento**
- Campo: DimDepartment[Department]
- Tipo: Dropdown
- Sidebar esquerda

**Slicer 3: Categoria de Despesa**
- Campo: DimExpenseCategory[Category]
- Tipo: Dropdown
- Sidebar esquerda

#### 6.2 Configurar Aplicação de Filtros

1. Selecione cada **Slicer**
2. **Format → General → Apply to all pages: On**
3. Teste filtros em todas as páginas

---

### FASE 7: FORMATAÇÃO E TEMAS (15 min)

#### 7.1 Aplicar Cores

**Paleta Padrão:**
- Primária: #0066CC (Azul)
- Secundária: #00B050 (Verde)
- Destaque: #FF6B6B (Vermelho)

#### 7.2 Formatar Números

1. Selecione cada visual
2. **Format → Values**
   - Moeda: R$ (pt-BR)
   - Percentual: 2 casas decimais
   - Milhares: Ativado

#### 7.3 Aplicar Fonte Padrão

- Título: Segoe UI, 18pt, Bold
- Subtítulo: Segoe UI, 14pt
- Corpo: Segoe UI, 12pt

---

### FASE 8: TESTE E VALIDAÇÃO (10 min)

**Checklist de Testes:**

- [ ] Todos os filtros funcionam
- [ ] Números batem com origem
- [ ] Sem erros de cálculo
- [ ] Visuais se carregam sem erro
- [ ] Formatação consistente
- [ ] Títulos descritivos
- [ ] Cores legíveis

---

## 🚀 Publicar no Power BI Service

1. **File → Publish**
2. Selecione espaço de trabalho
3. Configure permissões de acesso
4. Compartilhe link com stakeholders

---

## 🔧 Troubleshooting Comum

### Erro: "Column 'X' not found"
- Verifique se nome da coluna no dados bate com DAX
- Use: `COLUMNSTATISTICS` para ver nomes exatos

### Filtro não funciona
- Verifique se há relação entre tabelas
- Confirme se relação é M:1 (não 1:1)

### Valores errados
- Valide origem de dados
- Teste medida isoladamente
- Use: `EVALUATE` para debug

### Performance lenta
- Reduza período de datas
- Use agregação de dados
- Desabilite filtros desnecessários

---

## 📱 Dicas de Uso Eficiente

1. **Use Page Tooltips**: Crie página com detalhes que aparecem ao passar mouse
2. **Drill-Down**: Configure hierarquias (Ano → Mês → Dia)
3. **Bookmarks**: Salve estados diferentes do relatório
4. **Temas**: Use temas da Microsoft para consistência visual
5. **Refresh Agendado**: Configure atualização automática de dados

---

## 📞 Próximos Passos

- [ ] Implementar este template
- [ ] Adaptar para seus dados
- [ ] Criar versão customizada
- [ ] Documentar padrões da empresa
- [ ] Treinar usuários

---

## 💡 Exemplo Completo

Veja a pasta `exemplos/` para um projeto completo implementado com dados de amostra.

---

**Precisa de ajuda?** Consulte README.md ou entre em contato com alice.grazi@empresa.com
