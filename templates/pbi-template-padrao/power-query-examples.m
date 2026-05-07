// ====================================================================
// POWER QUERY EXAMPLES (M Language)
// Exemplos de transformações comuns para preparar dados
// ====================================================================

// ====================================================================
// LIMPAR E CARREGAR TABELA DE RECEITA
// ====================================================================

let
    Source = Excel.Workbook(File.Contents("C:\Data\Financeiro.xlsx"), null, true),
    Revenue_Sheet = Source{[Item="Receita"]}[Data],

    // Remover linhas vazias
    RemoveEmpty = Table.SelectRows(Revenue_Sheet, each [Data] <> null),

    // Renomear colunas
    RenameColumns = Table.RenameColumns(RemoveEmpty, {
        {"Data", "Date"},
        {"Departamento", "Department"},
        {"Fonte", "Source"},
        {"Quantidade", "Quantity"},
        {"Valor Unitário", "UnitPrice"},
        {"Valor Total", "Amount"}
    }),

    // Converter tipos de dados
    ConvertTypes = Table.TransformColumnTypes(RenameColumns, {
        {"Date", type date},
        {"Department", type text},
        {"Source", type text},
        {"Quantity", type number},
        {"UnitPrice", Currency.Type},
        {"Amount", Currency.Type}
    }),

    // Criar DateKey (YYYYMMDD)
    AddDateKey = Table.AddColumn(ConvertTypes, "DateKey",
        each Number.FromText(Text.Combine({
            Text.From(Date.Year([Date])),
            Text.PadStart(Text.From(Date.Month([Date])), 2, "0"),
            Text.PadStart(Text.From(Date.Day([Date])), 2, "0")
        })),
        type number),

    // Remover coluna original de data
    RemoveDateColumn = Table.RemoveColumns(AddDateKey, {"Date"}),

    // Reordenar colunas
    ReorderColumns = Table.ReorderColumns(RemoveDateColumn,
        {"DateKey", "Department", "Source", "Quantity", "UnitPrice", "Amount"})

in
    ReorderColumns


// ====================================================================
// LIMPAR E CARREGAR TABELA DE DESPESAS
// ====================================================================

let
    Source = Excel.Workbook(File.Contents("C:\Data\Financeiro.xlsx"), null, true),
    Expenses_Sheet = Source{[Item="Despesas"]}[Data],

    // Remover linhas vazias e cabeçalhos duplicados
    RemoveEmpty = Table.SelectRows(Expenses_Sheet, each [Data] <> null),
    RemoveDuplicateHeaders = Table.SelectRows(RemoveEmpty, each [Data] <> "Data"),

    // Renomear colunas
    RenameColumns = Table.RenameColumns(RemoveDuplicateHeaders, {
        {"Data", "Date"},
        {"Departamento", "Department"},
        {"Categoria", "Category"},
        {"Valor", "Amount"},
        {"Descrição", "Description"}
    }),

    // Converter tipos
    ConvertTypes = Table.TransformColumnTypes(RenameColumns, {
        {"Date", type date},
        {"Department", type text},
        {"Category", type text},
        {"Amount", Currency.Type},
        {"Description", type text}
    }),

    // Criar DateKey
    AddDateKey = Table.AddColumn(ConvertTypes, "DateKey",
        each Number.FromText(Text.Combine({
            Text.From(Date.Year([Date])),
            Text.PadStart(Text.From(Date.Month([Date])), 2, "0"),
            Text.PadStart(Text.From(Date.Day([Date])), 2, "0")
        })),
        type number),

    // Remover coluna original
    RemoveDateColumn = Table.RemoveColumns(AddDateKey, {"Date"})

in
    RemoveDateColumn


// ====================================================================
// LIMPAR E CARREGAR TABELA DE DEPARTAMENTOS
// ====================================================================

let
    Source = Excel.Workbook(File.Contents("C:\Data\Financeiro.xlsx"), null, true),
    Dept_Sheet = Source{[Item="Departamentos"]}[Data],

    // Remover duplicatas
    RemoveDuplicates = Table.Distinct(Dept_Sheet, {"Departamento"}),

    // Renomear e converter
    RenameColumns = Table.RenameColumns(RemoveDuplicates, {
        {"Departamento", "Department"},
        {"Gerente", "Manager"},
        {"Centro de Custo", "CostCenter"},
        {"Divisão", "Division"}
    }),

    ConvertTypes = Table.TransformColumnTypes(RenameColumns, {
        {"Department", type text},
        {"Manager", type text},
        {"CostCenter", type text},
        {"Division", type text}
    }),

    // Adicionar ID
    AddID = Table.AddIndexColumn(ConvertTypes, "DepartmentID", 1, 1),
    ReorderColumns = Table.ReorderColumns(AddID,
        {"DepartmentID", "Department", "Manager", "CostCenter", "Division"})

in
    ReorderColumns


// ====================================================================
// CRIAR TABELA DE DATAS DINAMICAMENTE
// ====================================================================

let
    StartDate = #date(2025, 1, 1),
    EndDate = #date(2026, 12, 31),

    // Gerar lista de datas
    DayCount = Duration.Days(EndDate - StartDate) + 1,
    DateList = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),

    // Converter para tabela
    DateTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),

    // Converter tipo
    ConvertType = Table.TransformColumnTypes(DateTable, {{"Date", type date}}),

    // Adicionar colunas calculadas
    AddYear = Table.AddColumn(ConvertType, "Year", each Date.Year([Date]), type number),
    AddMonth = Table.AddColumn(AddYear, "Month", each Date.Month([Date]), type number),
    AddMonthName = Table.AddColumn(AddMonth, "MonthName",
        each Text.Proper(Text.StartsWith(Date.MonthName([Date]), "january")), type text),
    AddQuarter = Table.AddColumn(AddMonthName, "Quarter",
        each "Q" & Text.From(Number.RoundUp([Month]/3, 0)), type text),
    AddDayOfWeek = Table.AddColumn(AddQuarter, "DayOfWeek",
        each Date.DayOfWeek([Date]) + 1, type number),
    AddDayName = Table.AddColumn(AddDayOfWeek, "DayName",
        each Date.DayOfWeekName([Date]), type text),
    AddIsWeekend = Table.AddColumn(AddDayName, "IsWeekend",
        each [DayOfWeek] >= 6, type logical),

    // Criar DateKey
    AddDateKey = Table.AddColumn(AddIsWeekend, "DateKey",
        each Number.FromText(Text.Combine({
            Text.From([Year]),
            Text.PadStart(Text.From([Month]), 2, "0"),
            Text.PadStart(Text.From(Date.Day([Date])), 2, "0")
        })),
        type number),

    // Reordenar
    ReorderColumns = Table.ReorderColumns(AddDateKey,
        {"DateKey", "Date", "Year", "Month", "MonthName", "Quarter", "DayOfWeek", "DayName", "IsWeekend"})

in
    ReorderColumns


// ====================================================================
// TRANSFORMAR DADOS DE ORÇAMENTO
// ====================================================================

let
    Source = Excel.Workbook(File.Contents("C:\Data\Financeiro.xlsx"), null, true),
    Budget_Sheet = Source{[Item="Orçamento"]}[Data],

    // Remover vazios
    RemoveEmpty = Table.SelectRows(Budget_Sheet, each [Período] <> null),

    // Renomear
    RenameColumns = Table.RenameColumns(RemoveEmpty, {
        {"Período", "Period"},
        {"Departamento", "Department"},
        {"Categoria", "Category"},
        {"Valor Orçado", "Amount"}
    }),

    ConvertTypes = Table.TransformColumnTypes(RenameColumns, {
        {"Period", type date},
        {"Department", type text},
        {"Category", type text},
        {"Amount", Currency.Type}
    }),

    // Extrair YYYYMM para período
    AddPeriodKey = Table.AddColumn(ConvertTypes, "PeriodKey",
        each Number.FromText(Text.Combine({
            Text.From(Date.Year([Period])),
            Text.PadStart(Text.From(Date.Month([Period])), 2, "0")
        })),
        type number),

    RemovePeriodColumn = Table.RemoveColumns(AddPeriodKey, {"Period"})

in
    RemovePeriodColumn


// ====================================================================
// MERGE DE TABELAS (Exemplo)
// ====================================================================

let
    Revenue = FactRevenue,  // Referência à tabela anterior

    // Merge com Departamento
    MergedWithDept = Table.NestedJoin(
        Revenue,
        {"Department"},
        DimDepartment,
        {"Department"},
        "Dept",
        JoinKind.LeftOuter),

    // Expandir colunas do departamento
    ExpandDept = Table.ExpandTableColumn(
        MergedWithDept,
        "Dept",
        {"DepartmentID", "Manager", "CostCenter", "Division"},
        {"DepartmentID", "Manager", "CostCenter", "Division"}),

    // Merge com Source
    MergedWithSource = Table.NestedJoin(
        ExpandDept,
        {"Source"},
        DimRevenueSource,
        {"Source"},
        "Src",
        JoinKind.LeftOuter),

    // Expandir colunas de source
    ExpandSource = Table.ExpandTableColumn(
        MergedWithSource,
        "Src",
        {"SourceID", "Region", "Channel"},
        {"SourceID", "Region", "Channel"})

in
    ExpandSource


// ====================================================================
// TRATAMENTO DE DADOS FALTANTES
// ====================================================================

let
    Source = Table1,

    // Substituir valores nulos por 0
    FillZeros = Table.FillDown(Source, {"Amount"}),

    // Substituir valores nulos por texto padrão
    FillText = Table.ReplaceValue(
        FillZeros,
        null,
        "Unknown",
        Replacer.ReplaceValue,
        {"Department"}),

    // Remover linhas completamente vazias
    RemoveCompleteEmpty = Table.SelectRows(FillText,
        each List.AllTrue(List.Transform(Record.ToList(_), each _ <> null))),

    // Remover valores duplicados mantendo primeiro
    RemoveDuplicates = Table.Distinct(RemoveCompleteEmpty, {"TransactionID"})

in
    RemoveDuplicates


// ====================================================================
// FUNÇÃO: FORMATAR MOEDA
// ====================================================================

// Adicionar esta função personalizada em Power Query Editor:

(value as number, optional decimals as number) =>
let
    Dec = if decimals = null then 2 else decimals,
    Formatted = Text.PadStart(Text.From(Number.RoundUp(value, Dec)), 10, " ")
in
    Formatted


// ====================================================================
// EXEMPLO: Combinar múltiplas abas de Excel
// ====================================================================

let
    Source = Excel.Workbook(File.Contents("C:\Data\Financeiro.xlsx"), true),

    // Filtrar apenas abas de receita (começa com "Rev_")
    RevenueTabs = Table.SelectRows(Source, each Text.StartsWith([Name], "Rev_")),

    // Combinar dados de todas as abas
    CombinedData = Table.Combine(RevenueTabs[Data]),

    // Adicionar coluna de origem (qual aba veio)
    AddSource = Table.AddColumn(CombinedData, "SourceTab",
        each RevenueTabs{[Name]})

in
    AddSource

