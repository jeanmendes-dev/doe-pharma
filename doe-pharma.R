# Instalar todos os pacotes necessários com dependências
#install.packages(c("rsm", "FrF2", "emmeans", "ggplot2", "dplyr", "broom", "DoE.base"), dependencies = TRUE)
# Carregar bibliotecas
library(FrF2)
library(rsm)
library(emmeans)
library(ggplot2)
library(dplyr)
library(broom)

# ==============================================================
# FUNÇÕES
# ==============================================================

design_frf2 <- function(factors, resolution = 4, randomize = TRUE) {
  if (factors <= 0) stop("Número de fatores deve ser > 0")
  
  # Determinar número mínimo de runs (deve ser potência de 2 >= factors)
  # Para FrF2, nfactors é o número de colunas, não o valor do fator!
  # Correção: FrF2 espera nfactors = número de fatores (ex: 4)
  # Mas nruns deve ser especificado ou inferido. Vamos usar FrF2() diretamente com nfactors.
  
  # FrF2 ajusta internamente o nruns com base na resolução
  design <- FrF2(
    nfactors = factors,
    resolution = resolution,
    randomize = randomize,
    factor.names = paste0("Fator_", 1:factors)
  )
  
  df <- as.data.frame(design)
  df$Run <- 1:nrow(df)
  return(df)
}

design_rsm <- function(factors, alpha = "rotatable") {
  formula_str <- paste("~", paste(factors, collapse = " + "))
  formula <- as.formula(formula_str)
  
  ccd_design <- ccd(
    formula,
    alpha = alpha,
    blocks = NULL
  )
  
  df <- as.data.frame(ccd_design)
  df$Run <- 1:nrow(df)
  return(df)
}

analyze_doe <- function(data, response, model_formula) {
  # Montar fórmula completa
  full_formula <- as.formula(paste(response, "~", model_formula))
  
  model <- lm(full_formula, data = data)
  
  summary_model <- summary(model)
  tidy_coef <- tidy(model)
  
  # Evitar emmeans problemático por enquanto
  # Vamos retornar apenas o modelo e sumário
  
  list(
    model = model,
    summary = summary_model,
    tidy_coefficients = tidy_coef
  )
}

plot_response_surface <- function(model, factor1, factor2) {
  # Só funciona se o modelo for do tipo rsm (criado com rsm())
  if (!inherits(model, "rsm")) {
    stop("Esta função só funciona com modelos 'rsm'. Use rsm() em vez de lm().")
  }
  
  grid <- expand.grid(
    seq(min(model$data[[factor1]]), max(model$data[[factor1]]), length.out = 50),
    seq(min(model$data[[factor2]]), max(model$data[[factor2]]), length.out = 50)
  )
  names(grid) <- c(factor1, factor2)
  grid$pred <- predict(model, newdata = grid)
  
  ggplot(grid, aes(x = .data[[factor1]], y = .data[[factor2]], fill = pred)) +
    geom_tile() +
    scale_fill_gradient(low = "blue", high = "red") +
    labs(title = "Superfície de Resposta", fill = "Resposta Predita") +
    theme_minimal()
}

# ==============================================================
# EXEMPLO DE USO - Validação de mistura homogênea
# ==============================================================

# 1. Criar planejamento FrF2
frf_plan <- design_frf2(factors = 4, resolution = 4)
print(frf_plan)

# 2. Simular resposta
set.seed(123)
frf_plan$Homogeneidade <- 80 + 
  5 * as.numeric(as.character(frf_plan$Fator_1)) +  # FrF2 gera fatores como "1" ou "-1" (strings)
  3 * as.numeric(as.character(frf_plan$Fator_2)) +
  rnorm(nrow(frf_plan), sd = 2)

# Visualizar dados
print(head(frf_plan))

# 3. Analisar
analise <- analyze_doe(
  data = frf_plan,
  response = "Homogeneidade",
  model_formula = "Fator_1 * Fator_2 + Fator_3"
)

# 4. Resultados
print(analise$summary)
print(analise$tidy_coefficients)

# 5. Diagnósticos
plot(analise$model, which = 1:2)
