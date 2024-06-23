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
	self
		schedule: [ allLabels
				do: [ :anotherLabel | anotherLabel background: BrGlamorousColors hoveredListItemColor ].
			(tokenLabels at: aByte ifAbsent: [ {} ])
				do: [ :anotherLabel | anotherLabel background: BrGlamorousColors newsBackgroundColor ] ]
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
					| aLabel |
					aLabel := BrLabel new
							margin: (BlInsets all: 1);
							aptitude: (BrGlamorousLabelAptitude new fontSize: 24)
									+ (BrLazyStyleCommonAptitude new
											default: [ :aStyle | self unhighlightGroupFor: aToken num ];
											hovered: [ :aStyle | self highlightGroupFor: aToken num ]);
							geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
							padding: (BlInsets all: 2);
							text: aToken name.
					aLabel explainer
						model: aToken num;
						isTarget: true.
					(tokenLabels at: aToken num ifAbsentPut: [ OrderedCollection new ])
						add: aLabel.
					allLabels add: aLabel ])
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
	self enqueueTask: (BlTaskAction new action: aTask)
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> unhighlight [
	self
		schedule: [ allLabels
				do: [ :anotherLabel | anotherLabel background: BrGlamorousColors hoveredListItemColor ] ]
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> unhighlightGroupFor: aByte [
	self
		schedule: [ (tokenLabels at: aByte ifAbsent: [ {} ])
				do: [ :anotherLabel | anotherLabel background: BrGlamorousColors hoveredListItemColor ] ]
]
