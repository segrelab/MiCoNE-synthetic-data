#/usr/bin/env Rscript

library(SpiecEasi)


data(amgut1.filt)  # rows are samples, cols are otus
depths <- rowSums(amgut1.filt)
amgut1.filt.n  <- t(apply(amgut1.filt, 1, norm_to_total))
amgut1.filt.cs <- round(amgut1.filt.n * min(depths))

d <- ncol(amgut1.filt.cs)  # otus
n <- nrow(amgut1.filt.cs)  # samples
e <- d

set.seed(10010)

topology_list <- c("cluster", "erdos_renyi", "hub", "scale_free", "block", "band")
# dist_list <- c("zinegbin", "zipois", "pois", "negbin", "lognorm")
dist_list <- c("zinegbin", "pois", "negbin")

for (topology in topology_list) {
    for (dist in dist_list) {
        cat("Generating data for", topology, "and", dist, "\n")
        # graph_options: cluster, erdos_renyi, hub, scale_free, block, band
        graph <- make_graph(topology, d, e)

        Prec  <- graph2prec(graph)
        Cor   <- cov2cor(prec2cov(Prec))
        rownames(Cor) <- paste0("sp", seq(1:d))
        colnames(Cor) <- rownames(Cor)

        # dist_options: zinegbin, zipois, pois, negbin, lognorm
        X <- synth_comm_from_counts(amgut1.filt.cs, mar=2, distr=dist, Sigma=Cor, n=n)
        X <- t(X)
        rownames(X) <- paste0("sp", seq(1:d))
        colnames(X) <- paste0("sample", seq(1:n))
        cnames <- c("#OTU ID", colnames(X))
        X_full <- cbind(rownames(X), X)
        colnames(X_full) <- cnames


        sample_metadata <- data.frame(md = rep(1, n))
        rownames(sample_metadata) <- colnames(X)

        # Writing
        folder_name <- paste("../../data/norta/input/", topology, "_", dist, sep = "")
        # Writing
        dir.create(folder_name, showWarnings = FALSE)
        Cor[graph == 0] <- 0
        write.table(Cor,
                    paste(folder_name, "/interaction_matrix.tsv", sep=""),
                    quote = FALSE,
                    sep = "\t",
                    col.names = NA)
        write.table(X_full,
                    paste(folder_name, "/otu_table.tsv", sep=""),
                    quote = FALSE,
                    sep = "\t",
                    row.names = FALSE)
        write.table(sample_metadata,
                    paste(folder_name, "/sample_metadata.tsv", sep=""),
                    quote =  FALSE,
                    sep = "\t",
                    col.names = NA)
    }
}

