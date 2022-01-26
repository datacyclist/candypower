########################################
# try clustering
########################################

source("01-read-data.R")
source("05-descriptive.R")

# blue: #0050AA
# red: #E60A14
# yellow: #FFF000

# clustering?

# try it. maybe we find clusters with similar products that all have a high win percentage?

# clustering doesn't really work well with binary attributes. but let's depict something.



dfgroups <- dat %>%
				mutate(
							 winpercent_class = cut(winpercent, labels=c('bottom', 'medium', 'top'), breaks=quantile(winpercent, probs=c(0,0.25,0.75,1)),include.lowest=TRUE),
							 competitorname = fct_reorder(competitorname, winpercent)
							 ) %>%
		pivot_longer(cols = -c(winpercent,competitorname,winpercent_class, sugarpercent, pricepercent), names_to = "candy_property", values_to = "response")  %>%
		mutate(
					 response = ifelse(response == 0, FALSE, TRUE)
					 )


p1 <- ggplot(dfgroups) +
	geom_jitter(aes(x=response, y=candy_property, colour=winpercent_class), alpha=0.75, width=0.4, height=0.2, size=5) +
	scale_colour_manual(values = c(bottom="#E60A14", medium="#FFF000", top="#005AAA"))  +
	theme_vsgls() +
	labs(title="selection based on candy properties?",
	     y = 'property name',
			 x = 'property false/true?'
			 ) +
	theme(legend.position="right")+
	guides(colour = guide_legend(override.aes = list(alpha = 1)))

png(filename=paste(figdirprefix, filedateprefix, "_clusters-products-properties.png", sep=''),
		width=1200, height=1200)
 print(p1)
dev.off()

# 1. you don't want the 'hard' or the 'fruity' property

# 2. properties chocolate, bar, nougat, peanutyalmondy, crispedricewafer seem good choices.

# let's combine some desired properties

dfgroupsc <- dat %>%
				mutate(
							 winpercent_class = cut(winpercent, labels=c('bottom', 'medium', 'top'), breaks=quantile(winpercent, probs=c(0,0.25,0.75,1)),include.lowest=TRUE),
							 competitorname = fct_reorder(competitorname, winpercent),

							 prop_chocolate_bar = ifelse(paste(chocolate, bar, sep="") == '11', 1, 0),
							 prop_crispedricewafer_bar = ifelse(paste(crispedricewafer, bar, sep="") == '11', 1, 0),
							 prop_nougat_bar = ifelse(paste(nougat, bar, sep="") == '11', 1, 0),
							 prop_peanutyalmondy_chocolate = ifelse(paste(peanutyalmondy, chocolate, sep="") == '11', 1, 0)
							 ) %>%
		pivot_longer(cols = -c(winpercent,competitorname,winpercent_class, sugarpercent, pricepercent), names_to = "candy_property", values_to = "response")  %>%
		mutate( response = ifelse(response == 0, FALSE, TRUE))


p1 <- ggplot(dfgroupsc) +
	geom_jitter(aes(x=response, y=candy_property, colour=winpercent_class), alpha=0.75, width=0.4, height=0.2, size=5) +
	scale_colour_manual(values = c(bottom="#E60A14", medium="#FFF000", top="#005AAA"))  +
	theme_vsgls() +
	geom_hline(yintercept=9.5, colour='forestgreen', size=2) +
	labs(title="refined selection based on candy properties?",
	     y = '(artificial) property name',
			 x = 'property false/true?'
			 ) +
	theme(legend.position="right")+
	guides(colour = guide_legend(override.aes = list(alpha = 1)))

png(filename=paste(figdirprefix, filedateprefix, "_clusters-products-artificial-properties.png", sep=''),
		width=1200, height=1200)
 print(p1)
dev.off()

# basic selection: the blue ones in the top right area?

# let's just pick the "crispedricewafer + bar" and the "peanutyalmondy + chocolate"

dfselect <- dat %>%
				mutate(
							 winpercent_class = cut(winpercent, labels=c('bottom', 'medium', 'top'), breaks=quantile(winpercent, probs=c(0,0.33,0.67,1)),include.lowest=TRUE),
							 competitorname = fct_reorder(competitorname, winpercent),

							 prop_chocolate_bar = ifelse(paste(chocolate, bar, sep="") == '11', 1, 0),
							 prop_crispedricewafer_bar = ifelse(paste(crispedricewafer, bar, sep="") == '11', 1, 0),
							 prop_nougat_bar = ifelse(paste(nougat, bar, sep="") == '11', 1, 0),
							 prop_peanutyalmondy_chocolate = ifelse(paste(peanutyalmondy, chocolate, sep="") == '11', 1, 0)
							 ) %>%
	filter(prop_crispedricewafer_bar == 1 | prop_peanutyalmondy_chocolate == 1)


