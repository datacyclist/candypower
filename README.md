# VSG, Case Study

Die Beliebtheit von Süsswaren soll ermittelt werden. Es stehen dazu
Beispieldaten von
[candy-power-ranking](https://github.com/fivethirtyeight/data/tree/master/candy-power-ranking)
zur Verfügung.

# Vorgehensweise

Der Datensatz wird eingelesen und exploriert, dann werden verschiedene Dinge ausprobiert.

## Deskriptiv 

Um nicht gleich auf die vollen Details gehen zu müssen, teile ich die Produkte
in drei Gruppen ein: top/medium/bottom (25/50/25%). 

<img alt="Produkte/Ranking" src="figs/20220126_descriptive-products-ranking.png?raw=true" width="400">

- Mir sind nicht alle Produkte bekannt :-)
- Unter den beliebtesten scheinen auch einige der bekanntesten zu sein: Twix,
	Kit Kat, Milky Way, Snickers, M&Ms. Gehört eh alles zu Mars, das sollte der
	Einkauf dann bedenken.
- Ausser den Eigenschaften der Produkte (siehe nächster Abschnitt) gibt es noch
	ein Ranking im Zuckergehalt und im Preisvergleich, jeweils nur relativ zu den
	anderen betrachteten Produkten.
- Keine echten Preise, keine echten Umsätze, keine Margen; d.h. das wird eine
	recht einseitige idealistische Betrachtung der Beliebtheit, die die
	Randbedingungen eines Supermarkts total vernachlässigt.

## Clustering / graphischer Drilldown

Bevor ich zur Regression komme, kam erst die Idee mit der Gruppenbildung. Gibt
es, basierend auf den Produkteigenschaften, ähnliche Produkte, die dann auch
ähnlich beliebt sind?

Clustering mit binären Variablen (*chocolate ja/nein*) ist etwas schwierig, aber vielleicht reicht 
hier schon ein einfacher grafischer Ansatz als Drilldown.

Die Daten werden wieder so in Gruppen aufgeteilt wie vorher. Jedes Süssigkeitenmerkmal wird mit TRUE/FALSE dargestellt.

Was wird gesucht? Gruppen mit möglichst vielen blauen Produkten oder mit
möglichst vielen roten Punkten, d.h. mit Eigenschaften, die auf beliebte
Produkte zutreffen und welchen, die auf unbeliebte Produkte zutreffen. Wenn
einzelne Gruppen z.B. nur blaue oder nur rote Produkte enthalten, ist die
zugehörige Eigenschaft ein sehr sicherer Hinweis zur Beliebtheit.

<img alt="single properties" src="figs/20220126_clusters-products-properties.png?raw=true" width="400">

Was sieht man, wenn man auf die rechte Spalte der Grafik schaut?

- *hard* hat nur gelbe/rote Produkte -- schlechte Eigenschaft
- ähnlich bei *fruity*, viel rot und gelb und zwei blaue -- schlechte Eigenschaft
- *crispedricewafer* hat nur blau/gelb -- gute Eigenschaft
- *bar* und *chocolate* haben auch mehrheitlich blaue Produkte -- gute Eigenschaften

Damit zeigt sich schon, dass man im Allgemeinen eher auf
*bar*/*chocolate*/*crispedricewafer* gehen sollte, weil diese Eigenschaften
häufig bei beliebten Produkten zu finden sind.

Kann man gute Eigenschaften kombinieren, quasi wie eine Kreuzung in der Genetik?

- *peanutyalmondy* + *chocolate*
- *nougat* + *bar*
- *crispedricewafer* + *bar*
- *chocolate* + *bar*

<img alt="combined properties" src="figs/20220126_clusters-products-artificial-properties.png?raw=true" width="400">

Der untere Teil der Grafik ist wieder wie vorher (Punkte jeweils zufällig
verschoben, aber auf den gleichen Seiten wie vorher). Oben kommen die vier
neuen Eigenschaften hinzu. Diese treten natürlich nicht mehr so häufig zusammen
auf wie die einzelnen Eigenschaften vorher.

Eine ziemlich sichere Süssigkeitenvariante ist *crispedricewafer* + *bar*. Von
sechs Produkten, die diese Kombination enthalten, sind fünf in der höchsten
Beliebtheitsklasse. Bei den anderen Kombinationen sind die Verteilungen ähnlich
gut. Damit ist also eine einfache Möglichkeit beschrieben, **beliebte**
Produkte auszuwählen (bzw. dann herzustellen oder einzulisten, wenn man keine
Eigenindustrie hat).


## Regression

Eine Regression ist naheliegend. Ob das sinnvoll ist, sie mit diesen Daten zu
machen, sei mal dahingestellt.

Ich sage also aus allen Eigenschaften der Produkte deren Beliebtheit voraus,
hier nur mit einem einfachen linearen Modell. Modelldetails sind im Code.

Die einzelnen Eigenschaften mit ihren positiven oder negativen Auswirkungen auf
die Beliebtheit des Produkts (und die spätere Beleibtheit des Käufers?) sieht man hier:

<img alt="product properties in regression" src="figs/20220126_regression-winpercent-products-properties.png?raw=true" width="400">

- *chocolate* ist am besten
- *fruity* ist im Gegensatz zur univariaten Analyse vorher hier doch ganz gut
- *hard* (candy) ist unbeliebt

Dasselbe wie vorher kann man hier auch nochmal machen, indem man die künstlich kombinierten
Eigenschaften hinzufügt. Dann sind die Eingabevariablen für die Regression allerdings nicht mehr
unabhängig voneinander.

<img alt="combined properties in regression" src="figs/20220126_regression-winpercent-products-combined-properties.png?raw=true" width="400">

Die zwei künstlichen Eigenschaften im oberen Teil der Grafik wirken sich
stärker positiv auf die Beliebtheit aus als die einzelnen Eigenschaften
darunter.


Als Bonus kann man auch noch probieren, auf dieselbe Weise den Zuckergehalt der
einzelnen Süssigkeiten vorherzusagen. Ob das sinnvoll ist, sei dahingestellt.

<img alt="sugar content in regression" src="figs/20220126_regression-sugarcontent-products-combined-properties.png?raw=true" width="400">

Immerhin: *caramel* und *hard* (candy) sagen den relativ höchsten Zuckergehalt
in den hier verwendeten Produkten voraus.

## Vorgehensweise für neues Produkt

1. Modell wie oben angegeben trainieren (supervised learning)
2. Eigenschaften des neuen Modells bestimmen (labeled data)
3. Modell verwenden, um Beliebtheit vorherzusagen (prediction)

## Ideen, Kommentare, Randbedingungen

- Für ähnliche Analysen sollte man sicher Verkaufszahlen (Umsatz/Stückzahl) von
	eigenen Produkten verwenden.
- Die Marge auf den Produkten muss natürlich berücksichtigt werden.
- Es wäre interessant, noch den Hersteller der Produkte mit zu berücksichtigen
	-- also ob z.B. Produkte von Mars, Ferrero oder Mondelez immer sehr beliebt
	sind. Dann könnte man sich vielleicht beim Einlisten oder beim Kreieren einer
	neuen Süssigkeit auf einen bestimmten Hersteller verlassen.
- Falls eine solche Regression (eventuell mit komplexeren Modellen) zum Einsatz
	kommt, sollte das Labeling der Produktdaten mit den gewünschten Eigenschaften
	von Hand gemacht werden.
- Umfragen sind wichtig, um auch negative Präferenzen der Käufer zu bekommen --
	Umsätze und Verkäufe drücken ja nur positive Präferenzen aus, ich weiss
	üblicherweise nicht, warum jemand ein Produkt **nicht** kauft.
- Es sollte *Pernigotti Gianduia Nero* permanent eingelistet werden.
- (to be continued)
