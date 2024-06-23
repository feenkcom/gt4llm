Class {
	#name : #GtLlmTokenizedStringEditor,
	#superclass : #BrHorizontalFlow,
	#instVars : [
		'result',
		'tokenLabels',
		'allLabels'
	],
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtLlmTokenizedStringEditor >> highlightGroupFor: aByte [
	"allLabels
		do: [ :anotherLabel | anotherLabel background: BrGlamorousColors hoveredListItemColor ]."
	(tokenLabels at: aByte ifAbsent: [ {} ])
		do: [ :anotherLabel | anotherLabel background: (Color blue alpha: 0.3) ]
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> initialize [
	super initialize.

	self matchParent
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> onResultAdded [
	self removeChildren.

	tokenLabels := Dictionary new.
	allLabels := OrderedCollection new.
	self
		addChildren: (self result tokens
				collect: [ :aToken | 
					| nameLabel container numberLabel |
					container := BrVerticalPane new fitContent
							margin: (BlInsets
									top: 2
									left: 2
									bottom: 5
									right: 2).
					nameLabel := BrLabel new
							aptitude: (BrGlamorousLabelAptitude new
									fontSize: 24;
									glamorousCodeFont);
							geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
							padding: (BlInsets all: 2);
							background: BrGlamorousColors hoveredListItemColor;
							text: aToken name.
					numberLabel := BrLabel new
							margin: (BlInsets all: 1);
							aptitude: (BrGlamorousLabelAptitude new foreground: Color gray);
							beSmallSize;
							text: aToken num.
					nameLabel explainer
						model: aToken num;
						isTarget: true.
					(tokenLabels at: aToken num ifAbsentPut: [ OrderedCollection new ])
						add: nameLabel.
					allLabels add: nameLabel.
					container
						when: BlClickEvent do: [:e | e target phlow spawnObject: aToken ];
						when: BlMouseOverEvent do: [ :e | self highlightGroupFor: aToken num ];
						when: BlMouseOutEvent do: [ :e | self unhighlightGroupFor: aToken num ].
					container
						addChild: nameLabel;
						addChild: numberLabel.
					container ])
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> result [
	^ result
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> result: anObject [
	result := anObject.

	self onResultAdded
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> schedule: aTask [
	aTask value.
"	self enqueueTask: (BlTaskAction new action: aTask)"
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> unhighlight [
	self
		schedule: [ allLabels
				do: [ :anotherLabel | anotherLabel background: BrGlamorousColors hoveredListItemColor ] ]
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> unhighlightGroupFor: aByte [
	(tokenLabels at: aByte ifAbsent: [ {} ])
		do: [ :anotherLabel | anotherLabel background: BrGlamorousColors hoveredListItemColor ]
]
