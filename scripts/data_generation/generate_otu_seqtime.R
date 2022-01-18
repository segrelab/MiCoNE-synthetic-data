#!/usr/bin/env Rscript

library(doFuture)
registerDoFuture()
plan(multicore)

library(seqtime)

get_interactions <- function(N) {
    A <- generateA(N, "klemm", pep = 10, c = 0.05)
    rownames(A) <- paste0("sp", seq(1:N))
    colnames(A) <- rownames(A)
    return(A)
}

# mode
# 1=each species receives round(count/N) counts,
# 2=sampled from uniform distribution with 0 as lower and count as upper bound,
# 3=dominant species takes 95 percent of the counts and all others split the remaining counts equally,
# 4=counts are sampled from a Poisson distribution with lambda set to count/N, (default)
# 5=using bstick function from vegan,
# 6=using geometric series with parameter k,
# 7=sample from the exponential distribution and scale with count/N
generate_data <- function(N, S, A, sampling_depth = 100000) {
    dataset <- generateDataSet(S, A)
    dataset_counts <- round(dataset * sampling_depth)
    rownames(dataset_counts) <- paste0("sp", seq(1:N))
    colnames(dataset_counts) <- paste0("sample", seq(1:S))
    cnames <- c("#OTU ID", colnames(dataset_counts))
    dataset_counts_full <- cbind(rownames(dataset_counts), dataset_counts)
    colnames(dataset_counts_full) <- cnames
    return(dataset_counts_full)
}

generate_samplemetadata <- function(S) {
    sample_metadata <- data.frame(md = rep(1, S))
    rownames(sample_metadata) <- paste0("sample", seq(1:S))
    return(sample_metadata)
}

N_list <- c(10, 25, 50, 100, 150, 200)
S_list <- c(50, 100, 200, 500)
foreach (N = N_list) %dopar% {
    for (S in S_list) {
        cat("Generating for N=", N, " S=", S)
        A <- get_interactions(N)
        dataset <- generate_data(N, S, A)
        sample_metadata <- generate_samplemetadata(S)
        folder_name <- paste("../../data/seqtime/input/", N, "N_", S, "S", sep = "")
        # Writing
        dir.create(folder_name, showWarnings = FALSE)
        write.table(
                    A,
                    paste(folder_name, "/interaction_matrix.tsv", sep=""),
                    quote = FALSE,
                    sep = "\t",
                    col.names = NA
        )
        write.table(
                    dataset,
                    paste(folder_name, "/otu_table.tsv", sep=""),
                    quote = FALSE,
                    sep = "\t",
                    row.names = FALSE
        )
        write.table(
                    sample_metadata,
                    paste(folder_name, "/sample_metadata.tsv", sep=""),
                    quote =  FALSE,
                    sep = "\t",
                    col.names = NA
        )
    }
}


