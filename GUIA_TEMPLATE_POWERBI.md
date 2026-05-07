# 📊 Guia: Criar Template Power BI IVECO

## Opção 1: Usar o Arquivo HTML como Referência Visual

Abra **iveco-pbi-template.html** em qualquer navegador (Chrome, Edge, Firefox) para ver como deve ficar o design final.

---

## Opção 2: Criar Template no Power BI Desktop (Recomendado)

### **Passo 1: Preparar Dados**

1. Abra **Power BI Desktop**
2. Vá em **Home → Get Data → SQL Server** (ou sua fonte de dados)
3. Importe dados com essas colunas:
   ```
   Data, Mês, Receita, EBIT, TaxaOcupação, KmRodados
   Período, Região, TipoVeículo
   KPI, Valor, Variação
   ```

### **Passo 2: Criar Página 1 - Visão Geral**

1. Clique em **+ Página** (ou Insert → New Page)
2. Renomeie para "Visão Geral"
3. Configure:
   - **Background**: Vai em Format Page → Page Background → Cor: #0a0f1e (cinza escuro)
   - **Adicione 5 cartões KPI**:
     - Card 1: Receita Neta = 45.2M€
     - Card 2: EBIT = 6.8M€
     - Card 3: Taxa Ocupação = 87.4%
     - Card 4: Km Mensais = 125.6M
     - Card 5: Frota em Rota = 142

4. **Adicione Gráficos**:
   - Line Chart: Receita por Mês (linha vermelha #e31836)
   - Bar Chart: Taxa de Ocupação por Região
   - Pie Chart: Distribuição de Frota por Tipo

### **Passo 3: Criar Página 2 - Operacional**

1. Nova página: "Operacional"
2. Adicione KPIs:
   - Velocidade Média = 62 km/h
   - Eficiência Combustível = 5.8 km/l
   - Ocorrências = 3
   - Entrega On-Time = 94.2%

3. Gráficos:
   - Line Chart: Km Rodados por Mês
   - Bar Chart: Taxa Ocupação vs Target
   - Column Chart: Horas Manutenção

### **Passo 4: Criar Página 3 - Financeiro**

1. Nova página: "Financeiro"
2. KPIs:
   - Receita por Km = 0.36€
   - Custo Operacional = 38.4M€
   - Margem Bruta = 15.1%
   - ROI Anualizado = 18.4%

3. Gráficos:
   - Combo Chart: Receita vs Custo (barras + linha)
   - Pie Chart: Mix de Receita por Segmento
   - Stacked Bar: Estrutura de Custos

### **Passo 5: Criar Página 4 - Performance**

1. Nova página: "Performance"
2. KPIs:
   - Performance Score = 8.6/10
   - Satisfação Cliente = 4.8/5.0
   - Conformidade Segurança = 99.2%
   - Emissões = 28.4g CO2/km

3. Gráficos:
   - **Radar Chart**: Segurança, Pontualidade, Eficiência, Satisfação
   - Line Chart: Performance Index ao longo dos meses
   - Clustered Bar: Score por Driver

### **Passo 6: Criar Página 5 - Sobre**

1. Nova página: "Sobre"
2. Adicione elementos de texto explicando o dashboard
3. Informações de versão e data de atualização

---

## Passo 7: Adicionar Filtros Globais

1. Vá em **View → Filters pane**
2. Arraste campos para "Filters on this page":
   - **Período** (YTD, Q1-Q4)
   - **Região** (Todas, Norte, Centro, Sul)
   - **TipoVeículo** (Todos, Pesado, Médio, Leve)

3. Configure como **buttons** (não como slicers tradicionais)

---

## Passo 8: Formatação Visual (Design)

### **Cores Corporativas IVECO**
```
Primary (Vermelho): #e31836
Accent (Azul): #2563eb
Fundo Escuro: #0a0f1e
Painel: #1f2937
Texto: #f3f4f6
```

### **Aplicar em Gráficos**
1. Selecione qualquer gráfico
2. Vá em **Format → Data colors**
3. Defina cores conforme acima

### **Aplicar Background Padrão**
1. Em cada página, clique em **Format page**
2. Background → Color → #0a0f1e
3. Transparency → 0%

---

## Passo 9: Salvar como Template (.pbit)

1. Vá em **File → Export as template**
2. Nomeie: `IVECO_FleetDashboard_v1.0.pbit`
3. Salve em pasta compartilhada da IVECO
4. Agora qualquer um pode usar este template para novos projetos!

---

## 📌 Dicas Importantes

✅ **Use Visual Hierarchy**:
- KPIs grandes no topo (50px font)
- Gráficos no meio
- Tabelas/detalhes em baixo

✅ **Mantenha Consistência**:
- Mesmas cores em todas as páginas
- Mesma fonte (Segoe UI ou Inter)
- Mesmos tamanhos de elementos

✅ **Performance**:
- Não use muitos visuais por página (máx 6-8)
- Use agregações em vez de dados brutos
- Implemente filtros para limitar dados

✅ **Reutilização**:
- Salve como `.pbit` (template)
- Documente o que cada página mostra
- Deixe exemplos de dados

---

## 🔗 Próximas Ações

1. Abra Power BI Desktop
2. Siga os passos acima
3. Customize com seus dados reais
4. Salve como template (.pbit)
5. Compartilhe com o time IVECO!

---

## 📊 Estrutura Final do Template

```
IVECO Fleet Dashboard
├── 📄 Visão Geral
│   ├── 5x KPI Cards
│   ├── Line Chart: Receita
│   ├── Bar Chart: Região
│   └── Pie Chart: Frota
├── 📄 Operacional
│   ├── 4x KPI Cards
│   ├── Line Chart: Km
│   ├── Bar Chart: Ocupação
│   └── Column Chart: Manutenção
├── 📄 Financeiro
│   ├── 4x KPI Cards
│   ├── Combo Chart: Rec vs Custo
│   ├── Pie Chart: Mix
│   └── Stacked Bar: Custos
├── 📄 Performance
│   ├── 4x KPI Cards
│   ├── Radar Chart
│   ├── Line Chart: Índice
│   └── Bar Chart: Drivers
└── 📄 Sobre
    └── Informações do Dashboard
```

---

**Pronto para começar? 🚀**

Qualquer dúvida nos passos, me avisa!
