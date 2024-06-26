Class {
	#name : #GtLlmTokenizedStringEditor,
	#superclass : #BrHorizontalFlow,
	#instVars : [
		'result',
		'tokenLabels',
		'allLabels',
		'decorationBlock',
		'tokenColors'
	],
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtLlmTokenizedStringEditor >> decorationBlock [
	^ decorationBlock
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> decorationBlock: anObject [
	decorationBlock := anObject
]

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
	tokenColors := Dictionary new.
	allLabels := OrderedCollection new.
	self
		addChildren: (self result tokens
				collectWithIndex: [ :aToken :anIndex | 
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
									glamorousCodeFont;
									editorMeasurement);
							geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
							padding: (BlInsets all: 2);
							background: BrGlamorousColors hoveredListItemColor;
							text: aToken name.
					numberLabel := BrLabel new
							margin: (BlInsets all: 1);
							aptitude: (BrGlamorousLabelAptitude new foreground: Color gray);
							beSmallSize;
							text: aToken number.

					self decorationBlock
						ifNotNil: [ self decorationBlock
								cull: nameLabel
								cull: numberLabel
								cull: aToken
								cull: anIndex ].
					nameLabel explainer
						model: aToken number;
						isTarget: true.
					(tokenLabels at: aToken number ifAbsentPut: [ OrderedCollection new ])
						add: nameLabel.
					allLabels add: nameLabel.
					tokenColors at: nameLabel put: nameLabel background.
					container
						when: BlClickEvent do: [ :e | e target phlow spawnObject: aToken ];
						when: BlMouseOverEvent do: [ :e | self highlightGroupFor: aToken number ];
						when: BlMouseOutEvent
							do: [ :e | self unhighlightGroupFor: aToken number ].
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
GtLlmTokenizedStringEditor >> unhighlightGroupFor: aByte [
	(tokenLabels at: aByte ifAbsent: [ {} ])
		do: [ :anotherLabel | anotherLabel background: (tokenColors at: anotherLabel) ]
]
