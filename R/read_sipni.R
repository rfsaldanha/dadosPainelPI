#' Read SIPNI files from Brazilian Health Ministry
#'
#' @param files_folder Path to folder containing CSV files from Brazilian Health Ministry
#' @param chunk_size Integer. Chunk size to read CSV files. Default 100,000 lines.
#' @return A lazy connection to SIPNI table in a SQLite database stored in a temporary folder.
#' @importFrom rlang .data

read_sipni <- function(files_folder, chunk_size = 100000){
  # Create temporary file for the database
  db_file_path <- tempfile()

  # Create temporary database and connection
  conn_sipni <- DBI::dbConnect(RSQLite::SQLite(), db_file_path)

  # SIPNI columns definitions
  cols_definitions <- readr::cols(
    document_id = readr::col_character(),
    paciente_id = readr::col_character(),
    paciente_idade = readr::col_double(),
    paciente_dataNascimento = readr::col_date(format = ""),
    paciente_enumSexoBiologico = readr::col_character(),
    paciente_racaCor_codigo = readr::col_character(),
    paciente_racaCor_valor = readr::col_character(),
    paciente_endereco_coIbgeMunicipio = readr::col_double(),
    paciente_endereco_coPais = readr::col_double(),
    paciente_endereco_nmMunicipio = readr::col_character(),
    paciente_endereco_nmPais = readr::col_character(),
    paciente_endereco_uf = readr::col_character(),
    paciente_endereco_cep = readr::col_character(),
    paciente_nacionalidade_enumNacionalidade = readr::col_character(),
    estabelecimento_valor = readr::col_double(),
    estabelecimento_razaoSocial = readr::col_character(),
    estalecimento_noFantasia = readr::col_character(),
    estabelecimento_municipio_codigo = readr::col_double(),
    estabelecimento_municipio_nome = readr::col_character(),
    estabelecimento_uf = readr::col_character(),
    vacina_grupoAtendimento_codigo = readr::col_character(),
    vacina_grupoAtendimento_nome = readr::col_character(),
    vacina_categoria_codigo = readr::col_double(),
    vacina_categoria_nome = readr::col_character(),
    vacina_lote = readr::col_character(),
    vacina_fabricante_nome = readr::col_character(),
    vacina_fabricante_referencia = readr::col_character(),
    vacina_dataAplicacao = readr::col_date(format = ""),
    vacina_descricao_dose = readr::col_character(),
    vacina_codigo = readr::col_double(),
    vacina_nome = readr::col_character(),
    sistema_origem = readr::col_character()
  )

  # Function to write chunk of lines to database
  chunk_to_bank <- function(x, pos){
    DBI::dbWriteTable(conn = conn_sipni, name = "sipni", value = x, append = TRUE)
  }

  # List of SIPNI files
  files_list <- list.files(path = files_folder, full.names = TRUE)

  # Remove table from database if exists
  if(DBI::dbExistsTable(conn = conn_sipni, name = "sipni")) DBI::dbRemoveTable(conn = conn_sipni, name = "sipni")

  # Read files from the list in chunks and store in temporary database
  for(f in files_list){
    message(f)
    readr::read_csv2_chunked(file = f, callback = readr::DataFrameCallback$new(chunk_to_bank), col_types = cols_definitions, chunk_size = chunk_size)
  }

  # Return a lazy connection to SIPNI table
  return(dplyr::tbl(conn_sipni, "sipni"))
}
