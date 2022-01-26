########################################
# try regression
########################################

source("01-read-data.R")
source("05-descriptive.R")

# blue: #0050AA
# red: #E60A14
# yellow: #FFF000

########################################
# predict win percentage based on properties
########################################


dfreg <- dat %>%
				mutate(
							 winpercent_class = cut(winpercent, labels=c('bottom', 'medium', 'top'), breaks=quantile(winpercent, probs=c(0,0.25,0.75,1)),include.lowest=TRUE),
							 competitorname = fct_reorder(competitorname, winpercent),
							 ) 

formula1 <- "winpercent ~ chocolate + fruity + caramel + peanutyalmondy + nougat + crispedricewafer + hard + bar + pluribus"

model1 <- lm(formula1, data=dfreg)

# plot coefficients:

dfplot <- data.frame(property = names(model1$coefficients),
										 coefficient = model1$coefficients) %>%
  filter(!(property == "(Intercept)")) %>%
	mutate(property_fact = fct_reorder(property, coefficient))


p1 <- ggplot(dfplot) +
	geom_col(aes(x=coefficient, y=property_fact), fill='#0050AA', alpha=0.95) +
	#scale_colour_manual(values = c(bottom="#E60A14", medium="#FFF000", top="#005AAA"))  +
	theme_vsgls() +
	labs(title="Regression: which properties are best for predicting win percentage?",
			 x = 'added value of property',
	     y = 'property name'
			 ) +
	theme(legend.position="right")+
	guides(colour = guide_legend(override.aes = list(alpha = 1)))

png(filename=paste(figdirprefix, filedateprefix, "_regression-winpercent-products-properties.png", sep=''),
		width=900, height=600)
 print(p1)
dev.off()

########################################
# use combined properties in regression model?
########################################

dfreg <- dat %>%
				mutate(
							 winpercent_class = cut(winpercent, labels=c('bottom', 'medium', 'top'), breaks=quantile(winpercent, probs=c(0,0.25,0.75,1)),include.lowest=TRUE),
							 competitorname = fct_reorder(competitorname, winpercent),

							 prop_chocolate_bar = ifelse(paste(chocolate, bar, sep="") == '11', 1, 0),
							 prop_crispedricewafer_bar = ifelse(paste(crispedricewafer, bar, sep="") == '11', 1, 0),
							 prop_nougat_bar = ifelse(paste(nougat, bar, sep="") == '11', 1, 0),
							 prop_peanutyalmondy_chocolate = ifelse(paste(peanutyalmondy, chocolate, sep="") == '11', 1, 0)
							 ) 

formula2 <- "winpercent ~ prop_crispedricewafer_bar + prop_peanutyalmondy_chocolate + chocolate + fruity + caramel + peanutyalmondy + nougat + crispedricewafer + hard + bar + pluribus"

model1 <- lm(formula2, data=dfreg)

# plot coefficients:

dfplot <- data.frame(property = names(model1$coefficients),
										 coefficient = model1$coefficients) %>%
  filter(!(property == "(Intercept)")) %>%
	mutate(property_fact = fct_reorder(property, coefficient))


p1 <- ggplot(dfplot) +
	geom_col(aes(x=coefficient, y=property_fact), fill='#0050AA', alpha=0.95) +
	theme_vsgls() +
	labs(title="Regression: which properties are best for predicting win percentage?",
			 x = 'added value of property',
	     y = 'property name'
			 ) +
	geom_hline(yintercept=9.5, color='forestgreen', size=1) +
	theme(legend.position="right")+
	guides(colour = guide_legend(override.aes = list(alpha = 1)))

png(filename=paste(figdirprefix, filedateprefix, "_regression-winpercent-products-combined-properties.png", sep=''),
		width=900, height=600)
 print(p1)
dev.off()


########################################
# predict sugar content based on properties? :-)
########################################

dfreg <- dat %>%
				mutate(
							 winpercent_class = cut(winpercent, labels=c('bottom', 'medium', 'top'), breaks=quantile(winpercent, probs=c(0,0.25,0.75,1)),include.lowest=TRUE),
							 competitorname = fct_reorder(competitorname, winpercent),

							 prop_chocolate_bar = ifelse(paste(chocolate, bar, sep="") == '11', 1, 0),
							 prop_crispedricewafer_bar = ifelse(paste(crispedricewafer, bar, sep="") == '11', 1, 0),
							 prop_nougat_bar = ifelse(paste(nougat, bar, sep="") == '11', 1, 0),
							 prop_peanutyalmondy_chocolate = ifelse(paste(peanutyalmondy, chocolate, sep="") == '11', 1, 0)
							 ) 

formula3 <- "sugarpercent ~ chocolate + fruity + caramel + peanutyalmondy + nougat + crispedricewafer + hard + bar + pluribus"
model3 <- lm(formula3, data=dfreg)

# plot coefficients:

dfplot <- data.frame(property = names(model3$coefficients),
										 coefficient = model3$coefficients) %>%
  filter(!(property == "(Intercept)")) %>%
	mutate(property_fact = fct_reorder(property, coefficient))


p1 <- ggplot(dfplot) +
	geom_col(aes(x=coefficient, y=property_fact), fill='#E60A14', alpha=0.75) +
	theme_vsgls() +
	labs(title="Regression: which properties are best for predicting sugar content?",
			 x = 'added value of property (for sugar content)',
	     y = 'property name'
			 ) +
	theme(legend.position="right")+
	guides(colour = guide_legend(override.aes = list(alpha = 1)))

png(filename=paste(figdirprefix, filedateprefix, "_regression-sugarcontent-products-combined-properties.png", sep=''),
		width=1100, height=600)
 print(p1)
dev.off()


