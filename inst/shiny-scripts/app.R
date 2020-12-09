library(shiny)
# This example is adapted from
# Grolemund, G. (2015). Learn Shiny - Video Tutorials. URL:https://shiny.rstudio.com/tutorial/

ui <- fluidPage(
  navbarPage(
    "MethylExpress",
    tabPanel("Help",
             h1("Welcome to MethylExpress!"),
             helpText("Here you can learn how to interact with the shiny app for
                      MethylExpress."),
             h3("Tabs Available"),
             helpText("Through this shiny app, you are able to access the four
                      functions in the MethylExpress package using the four tabs
                      to the right of the 'Help' tab."),
             h4("1. Gene Expression Diff"),
             h5("What does this tab / function do?"),
             p("This function allows compare two different RNAseq data from two
               different DNA strands (preferably with different methylation) and
               see the n genes with the largest difference in expression between
               the two RNAseq datasets in a graph. The user is able to specify
               n, which is the number of genes shown in the graphical output."),
             h5("Example using data from the MethyExpress package:"),
             p("Using the datasets", em("BeforeBariatricSurgery"), "and",
               em("AfterBariatricSurgery"), "and the default value for n
               (n = 1 in the default) you are able
               to see a bar graph output!"),

             h4("2. Methylated Cs"),
             h5("What does this function do?"),
             p("This function allows for user to compare a DNA sequence before
               and after bisulfite conversion, and determine which cytosine
               nucleotides are methylated or not. This function will output the
               original DNA strand (before bisulfite conversion) with the
               cytosines that are methylated highlighted."),
             h5("Example you can type in:"),
             p("Using the strings", em("acac"), "and",
               em("acat"), "you will see the second c be highlighted, since it
               is considered methylated (since after bisulfite conversion it is
               still a 'c'), while the second 'c' is not highlighted
               since it is not methylated (has been converted to a 't')!"),

             h4("3. CpG Islands"),
             h5("What does this function do?"),
             p("This function allows for users to be able to determine how many
               CpG islands are present in their DNA strand, as well as view
               where the CpG islands are in the DNA strand as this function
               will output the nucleotides of the given strand with the CpG
               islands highlighted."),
             h5("Example using data from the MethyExpress package:"),
             p("Using the string from", em("MethylExpress::PossibleCpGIslands"),
             "you will see the CpG islands in the DNA strand get highlighted!"),

             h4("4. DNA Seq Diff"),
             h5("What does this function do?"),
             p("This function allows for users to be able to determine which
               nucleotides between two strands of DNA are different. This
               function will output the two DNA strands with the nucleotides
               that differ between the strands highlighted."),
             h5("Example using data from the MethyExpress package:"),
             p("Using the strings from",
               em("MethylExpress::MethylationObservation$originalDNA"),
               "and", em("MethylExpress::MethylationObservation$bisulfite"),
               "you will see both DNA strands, and the nucleotides that differ
               between the two strands will be highlighted.")
    ),
    tabPanel("Gene Expression Diff",
             titlePanel("Find Differences of Gene Expression in Two RNASeq Strands"),
             sidebarLayout(
               sidebarPanel (
                 helpText("You can use this page to find n genes with the
                          largest difference in count expression between two
                          RNASeq strands."),
                 helpText("NOTE: the two input files MUST be .rda files"),
                 fileInput(inputId = "RNAFile1",
                           label = "Choose a file for your first RNASeq data"),
                 fileInput(inputId = "RNAFile2",
                           label = "Choose another file for the other RNASeq data"),
                 numericInput(inputId = "n",
                              label = "Choose the number of genes to be highlighted",
                              value = 1)
               ),
               mainPanel(
                 helpText("The plot takes a bit of time to load after
                          selecting the input parameters. Please be patient as
                          the graph loads."),
                 plotOutput("hist")
               )
             )
    ),
    tabPanel("Methylated Cs",
             titlePanel("Find the Methylated Cytosines in a DNA strand"),
             sidebarLayout(
               sidebarPanel (
                 helpText("You can use this page to find which cytosines were
                          methylated and which weren't."),
                 helpText("Input into the top box
                          the DNA strand (in string form) before bisulfite
                          conversion, and in the bottom box the DNA strand
                          (in string form) after bisulfite conversion."),
                 textInput(inputId="MethStrand1", label = "Input a string of nucleotides
                           before bisulfite conversion"),
                 textInput(inputId="MethStrand2", label = "Input a string of nucleotides
                           after bisulfite conversion"),
               ),
               mainPanel(
                 helpText("The output here highlights the cytosines from the
                          original DNA strand that are methylated."),
                 htmlOutput("methylatedFile")
               )
             )
    ),
    tabPanel("CpG Islands",
             titlePanel("Find the CpG Islands in a DNA strand"),
             sidebarLayout(
               sidebarPanel (
                 helpText("You can use this page to find which nucleotides in
                          a DNA strand are part of a CpG island."),
                 textInput(inputId="CpGNucs", label = "Input a string of nucleotides
                           where you want to discover the CpG islands"),
               ),
               mainPanel(
                 helpText("The output here highlights the nucleotides from the
                          original DNA strand that are part of the CpG Islands."),
                 htmlOutput("CpGFile")
               )
             )
    ),
    tabPanel("DNA Seq Diff",
             titlePanel("Find the Differences in Two DNA Sequences"),
             helpText("You can use this page to find which nucleotides are
                      different between two DNA strands."),
             sidebarLayout(
               sidebarPanel (
                 textInput(inputId="DNAStrand1", label = "Input a string of nucleotides
                           for one DNA strand"),
                 textInput(inputId="DNAStrand2", label = "Input a string of nucleotides
                           for another DNA strand"),
               ),
               mainPanel(
                 helpText("The output here highlights the nucleotides that are
                          different between the two strands."),
                 htmlOutput("DNADiffDataFile")
               )
             )
    )
  ),

)

server <- function(input, output) {

  output$hist <- renderPlot({

    inFile1 <- input$RNAFile1
    inFile2 <- input$RNAFile2
    n <- input$n

    if (is.null(inFile1) || is.null(inFile2) || is.na(n)) {
      return(NULL)
    }

    RNASeq1 <- get(load(inFile1$datapath))
    RNASeq2 <- get(load(inFile2$datapath))
    return (differencesInGeneExpression(RNASeq1, RNASeq2, n))
  })

  output$methylatedFile <- renderUI({

    origDNA <- input$MethStrand1
    bisulfiteDNA <- input$MethStrand2

    if (origDNA == "" || bisulfiteDNA == "") {
      return(NULL)
    }

    methylationDataFile <- findMethylatedCytosines(origDNA, bisulfiteDNA)
    return(includeHTML(methylationDataFile))
  })

  output$CpGFile <- renderUI({

    CpGNucs <- input$CpGNucs

    if (CpGNucs == "") {
      return(NULL)
    }

    CpGDataFile <- findCpGIslands(CpGNucs)
    print(CpGDataFile)
    return(includeHTML(CpGDataFile))
  })

  output$DNADiffDataFile <- renderUI({

    DNAStrand1 <- input$DNAStrand1
    DNAStrand2 <- input$DNAStrand2

    if (DNAStrand1 == "" || DNAStrand2 == "") {
      return(NULL)
    }

    DNAStrandDataFile <- findDifferencesInDNASequence(DNAStrand1, DNAStrand2)
    return(includeHTML(DNAStrandDataFile))
  })
}
shiny::shinyApp(ui = ui, server = server)
