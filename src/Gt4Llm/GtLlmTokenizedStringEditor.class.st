Class {
	#name : #GtLlmTokenizedStringEditor,
	#superclass : #BrHorizontalFlow,
	#instVars : [
		'result'
	],
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtLlmTokenizedStringEditor >> initialize [
	super initialize.

	self matchParent
]

{ #category : #accessing }
GtLlmTokenizedStringEditor >> onResultAdded [
	| tokenLabels allLabels |
	self removeChildren.

	tokenLabels := Dictionary new.
	allLabels := OrderedCollection new.
	self
		addChildren: (self result tokens
				collect: [ :aToken | 
					| aLabel |
					aLabel := BrLabel new
							margin: (BlInsets all: 3);
							aptitude: BrGlamorousLabelAptitude new
									+ (BrLazyStyleCommonAptitude new
											default: [ :aStyle | 
												(tokenLabels at: aToken num ifAbsent: [ {} ])
													do: [ :anotherLabel | anotherLabel background: BrGlamorousColors hoveredListItemColor ] ];
											hovered: [ :aStyle | 
												allLabels
													do: [ :anotherLabel | anotherLabel background: BrGlamorousColors hoveredListItemColor ].
												(tokenLabels at: aToken num ifAbsent: [ {} ])
													do: [ :anotherLabel | anotherLabel background: BrGlamorousColors newsBackgroundColor ] ]);
							geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
							padding: (BlInsets all: 1);
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
