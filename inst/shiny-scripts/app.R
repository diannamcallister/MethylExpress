library(shiny)
# This example is adapted from
# Grolemund, G. (2015). Learn Shiny - Video Tutorials. URL:https://shiny.rstudio.com/tutorial/

ui <- fluidPage(
  navbarPage(
    "MethylExpress",
    tabPanel("Gene Expression Diff",
             titlePanel("Find Differences of Gene Expression in Two RNASeq Strands"),
             sidebarLayout(
               sidebarPanel (
                 fileInput(inputId = "RNAFile1",
                           label = "Choose a file for your first RNASeq data"),
                 fileInput(inputId = "RNAFile2",
                           label = "Choose another file for the other RNASeq data"),
                 numericInput(inputId = "n",
                              label = "Choose the number of genes to be highlighted",
                              value = 1)
               ),
               mainPanel(
                 plotOutput("hist")
               )
             )
    ),
    tabPanel("Methylated Cs",
             titlePanel("Find the Methylated Cytosines in a DNA strand"),
             sidebarLayout(
               sidebarPanel (
                 textInput(inputId="MethStrand1", label = "Input a string of nucleotides
                           before bisulfite conversion"),
                 textInput(inputId="MethStrand2", label = "Input a string of nucleotides
                           after bisulfite conversion"),
               ),
               mainPanel(
                 htmlOutput("methylatedFile")
               )
             )
    ),
    tabPanel("CpG Islands",
             titlePanel("Find the CpG Islands in a DNA strand"),
             sidebarLayout(
               sidebarPanel (
                 textInput(inputId="CpGNucs", label = "Input a string of nucleotides
                           Where you want to discover the CpG islands"),
               ),
               mainPanel(
                 htmlOutput("CpGFile")
               )
             )
    ),
    tabPanel("DNA Seq Diff",
             titlePanel("Find the Differences in Two DNA Sequences"),
             helpText("helpText"),
             sidebarLayout(
               sidebarPanel (
                 textInput(inputId="DNAStrand1", label = "Input a string of nucleotides
                           for one DNA strand"),
                 textInput(inputId="DNAStrand2", label = "Input a string of nucleotides
                           for another DNA strand"),
               ),
               mainPanel(
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
