Class {
	#name : #GtOpenAIWardleyMapActionThreadMessage,
	#superclass : #GtOpenAIThreadMessage,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> asViewModel [
	^ GtLlmActionThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> explanationCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'explanation' ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmActionThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtExplanationFor: aView [
	<gtView>
	<gtLlmMessageView>
	self explanationCodeBlock ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Explanation';
		priority: 2;
		text: [ self explanationCodeBlock code value ];
		styler: (GtLlmMessageStyler new threadMessageViewModel: self)
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtWardleyMapFor: aView [
	<gtView>
	<gtLlmMessageView>
	self mapCodeBlock ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Map';
		priority: 2;
		stencil: [ GtWardleyMapElement new
				wardleyMapViewModel: (GtWardleyMapViewModel new
						wardleyMapModel: (GtWardleyMapParser parse: self mapCodeBlock code value) asWardleyMapModel);
				vExact: 500 ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> mapCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'wardley-map' ]
		ifNone: [ nil ]
]
