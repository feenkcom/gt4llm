Class {
	#name : #GtLlmTokenizedExplainer,
	#superclass : #BrVerticalPane,
	#instVars : [
		'result',
		'bytesList',
		'editor'
	],
	#category : 'Gt4Llm-GToolkit-Tokenization'
}

{ #category : #accessing }
GtLlmTokenizedExplainer >> bytesList [
	^ bytesList
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> bytesList: anObject [
	bytesList := anObject
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> editor [
	^ editor
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> editor: anObject [
	editor := anObject
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> initialize [
	super initialize.

	self matchParent.

	self initializeEditor.
	self initializeBytesList.

	self addChild: self editor as: #editor.
	self addChild: self bytesList as: #'bytes-list'.
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> initializeBytesList [
	self
		bytesList: (BrHorizontalFlow new matchParent
				padding: (BlInsets all: 5);
				background: Color white;
				aptitude: BrShadowAptitude new)
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> initializeEditor [
	self editor: (GtLlmTokenizedStringEditor new padding: (BlInsets all: 5))
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> onResultUpdated [
	self editor result: self result.
	self updateBytesList
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> result [
	^ result
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> result: anObject [
	result := anObject.
	
	self onResultUpdated
]

{ #category : #accessing }
GtLlmTokenizedExplainer >> updateBytesList [
	| tokenSet |
	self bytesList removeChildren.

	tokenSet := self result tokens collect: #num as: Set.
	tokenSet := tokenSet asSortedCollection.

	tokenSet
		do: [ :aTokenNumber | 
			self bytesList
				addChild: (BrLabel new
						
						aptitude: (BrGlamorousLabelAptitude new)
								+ (GtExplainerExplanationAptitude new explanationModel: aTokenNumber)
								+ (BrLazyStyleCommonAptitude new
										default: [ :aStyle | self editor unhighlightGroupFor: aTokenNumber ];
										hovered: [ :aStyle | 
											self editor highlightGroupFor: aTokenNumber.
											aStyle background: BrGlamorousColors newsBackgroundColor ]);
						geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
						text: aTokenNumber asString;
						padding: (BlInsets all: 5)) ]
]
