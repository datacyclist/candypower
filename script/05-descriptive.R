########################################
# read csv data from github
########################################

source("01-read-data.R")

# a certain retail store's colors:
#
# blue: #0050AA
# red: #E60A14
# yellow: #FFF000

# let's get a ranking

dfranking <- dat %>%
				select(competitorname, winpercent) %>%
				mutate(
							 winpercent_colors = cut(winpercent, labels=c('#E60A14', '#FFF000', '#0050AA'), breaks=quantile(winpercent, probs=c(0,0.25,0.75,1)),include.lowest=TRUE),
							 winpercent_class = cut(winpercent, labels=c('bottom', 'medium', 'top'), breaks=quantile(winpercent, probs=c(0,0.25,0.75,1)),include.lowest=TRUE)
							 ) %>%
				mutate(competitorname = fct_reorder(competitorname, winpercent))


p1 <- ggplot(dfranking) +
	geom_col(aes(x=competitorname, y=winpercent, fill=winpercent_class), colour="black") +
	scale_fill_manual(values = c(bottom="#E60A14", medium="#FFF000", top="#005AAA"))  +
	#geom_text(aes(x=Sprache_Vortrag, y=-1, label=Anzahl), cex=10, hjust=0.5) +
	#scale_fill_brewer(palette="Set2", guide=guide_legend(reverse=FALSE)) +
	#facet_wrap("winpercent_class", scale='free_y') +
	coord_flip() +
	theme_vsgls() +
	labs(title="Ranking candy products",
	     y = 'win percentage',
			 x = 'product name'
			 ) +
	theme(legend.position="none")

png(filename=paste(figdirprefix, filedateprefix, "_descriptive-products-ranking.png", sep=''),
		width=900, height=2200)
 print(p1)
dev.off()

# sorry, one of my three screens has a portrait orientation :-)
