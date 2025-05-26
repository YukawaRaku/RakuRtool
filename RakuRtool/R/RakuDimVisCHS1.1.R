RakuDimVis <- function(
    features,
    label = NULL,
    methods = c("PCA", "tSNE", "UMAP"),
    method_params = list(),
    group_n = 4,
    top = NULL,
    group_labels = NULL,         # 可选：自定义分组名
    legend_names = list(group=NULL, brightness=NULL), # 图例名（已默认空）
    custom_titles = list(),      # 可选：自定义每张图标题
    axis_labels_list = list()    # 可选：自定义每个方法坐标轴名
) {
  # 特征数据转为数值矩阵
  if (!is.matrix(features)) features <- as.matrix(features)
  storage.mode(features) <- "numeric"

  # 自动转label为向量
  if (!is.null(label)) {
    if (is.data.frame(label)) {
      label <- label[,1]
    }
    if (is.factor(label)) {
      label <- as.numeric(as.character(label))
    }
  }
  if (!is.null(label) && length(label) != nrow(features)) {
    stop("标签长度与特征样本数不一致！")
  }

  # 默认参数设置
  param <- list()
  param$PCA <- list(center = TRUE, scale. = FALSE)
  param$TSNE <- list(dims = 2, perplexity = 30, theta = 0.5, max_iter = 1000)
  param$UMAP <- list(n_components = 2, n_neighbors = 15, min_dist = 0.01)
  for (m in names(method_params)) {
    M <- toupper(m)
    if (M %in% names(param)) {
      param[[M]] <- modifyList(param[[M]], method_params[[m]])
    }
  }

  plots <- list()

  make_scatter <- function(df, title, xlab="Dim 1", ylab="Dim 2",
                           top=NULL,
                           legend_group_name=NULL,
                           legend_brightness_name=NULL) {
    p <- ggplot(df, aes(x=Dim1, y=Dim2)) +
      stat_ellipse(aes(fill=Group), geom="polygon", alpha=0.3, color=NA, level=0.95, show.legend=TRUE) +
      scale_fill_viridis_d(option="plasma", name=legend_group_name) +
      ggnewscale::new_scale_fill() +
      geom_point(aes(fill=Brightness), shape=21, size=3, color="black") +
      scale_fill_viridis_c(option="plasma", name=legend_brightness_name) +
      theme_bw() +
      labs(title=title, x=xlab, y=ylab) +
      theme(
        plot.title=element_text(hjust=0.5, size=16, face="bold"),
        legend.position="right"
      )
    # 高亮top点
    if (!is.null(top) && top > 0) {
      df_top <- df[order(-df$Brightness), ][1:top,]
      p <- p + ggrepel::geom_label_repel(
        data=df_top,
        aes(label=paste0(row.names(df_top), "\n", round(Brightness, 2))),
        fill="lightyellow",
        size=3.5,
        box.padding=0.4,
        segment.color=NA # 去掉箭头线
      )
    }
    p
  }

  for (method in toupper(methods)) {
    if (method == "PCA") {
      res <- do.call(prcomp, c(list(x = features), param$PCA))
      coords <- res$x[, 1:2]
      explained <- summary(res)$importance[2, 1:2] * 100
      axis_labels <- paste0("PC", 1:2, " (", sprintf("%.1f%%", explained), ")")
      plot_title <- "PCA"
    } else if (method == "TSNE") {
      res <- do.call(Rtsne, c(list(X = features), param$TSNE))
      coords <- res$Y[, 1:2]
      axis_labels <- c("t-SNE 1", "t-SNE 2")
      plot_title <- "t-SNE"
    } else if (method == "UMAP") {
      res <- do.call(umap, c(list(X = features), param$UMAP))
      coords <- res[, 1:2]
      axis_labels <- c("UMAP 1", "UMAP 2")
      plot_title <- "UMAP"
    } else {
      next
    }

    df <- data.frame(coords, Brightness = label, row.names = rownames(features))
    colnames(df)[1:2] <- c("Dim1", "Dim2")
    # 分组名
    if (is.null(group_labels)) {
      df$Group <- cut(label, breaks = group_n, labels = paste0("Q", 2:(group_n + 1)))
    } else {
      if (length(group_labels) != group_n) {
        stop("group_labels的长度必须等于group_n！")
      }
      df$Group <- cut(label, breaks = group_n, labels = group_labels)
    }
    # 标题/坐标轴名
    title_use <- if (!is.null(custom_titles[[method]])) custom_titles[[method]] else plot_title
    axis_labels_use <- if (!is.null(axis_labels_list[[method]])) axis_labels_list[[method]] else axis_labels
    # 图例名
    legend_group_name <- if (!is.null(legend_names$group)) legend_names$group else NULL
    legend_brightness_name <- if (!is.null(legend_names$brightness)) legend_names$brightness else NULL

    plots[[method]] <- make_scatter(
      df,
      title = title_use,
      xlab = axis_labels_use[1],
      ylab = axis_labels_use[2],
      top = top,
      legend_group_name = legend_group_name,
      legend_brightness_name = legend_brightness_name
    )
  }
return(plots)

  }
show_all <- function(plots) {
  n <- length(plots)
  ncol <- ceiling(sqrt(n))
  nrow <- ceiling(n / ncol)
  gridExtra::grid.arrange(grobs = plots, ncol = ncol, nrow = nrow)
}
