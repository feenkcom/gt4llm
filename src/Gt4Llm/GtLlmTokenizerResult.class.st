Class {
	#name : #GtLlmTokenizerResult,
	#superclass : #Object,
	#instVars : [
		'result',
		'input',
		'model'
	],
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtLlmTokenizerResult >> gtResultFor: aView [
	<gtView>
	^ aView explicit
		title: 'Tokenized';
		priority: 1;
		stencil: [ | tokenLabels allLabels |
			tokenLabels := Dictionary new.
			allLabels := OrderedCollection new.
			BrHorizontalFlow new matchParent
				addChildren: (self result tokens
						collect: [ :aToken | 
							| aLabel |
							aLabel := BrLabel new
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
							(tokenLabels at: aToken num ifAbsentPut: [ OrderedCollection new ])
								add: aLabel.
							allLabels add: aLabel ]) ]
]

{ #category : #accessing }
GtLlmTokenizerResult >> input [
	^ input
]

{ #category : #accessing }
GtLlmTokenizerResult >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLlmTokenizerResult >> model [
	^ model
]

{ #category : #accessing }
GtLlmTokenizerResult >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmTokenizerResult >> result [
	^ result
]

{ #category : #accessing }
GtLlmTokenizerResult >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtLlmTokenizerResult >> tokenCount [
	^ self result tokens size
]
