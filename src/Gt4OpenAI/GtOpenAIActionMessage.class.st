Class {
	#name : #GtOpenAIActionMessage,
	#superclass : #GtOpenAIMessage,
	#traits : 'TGtActionMessage',
	#classTraits : 'TGtActionMessage classTrait',
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIActionMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	self textBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 1;
		styler: (BlCompositeStyler new
				stylers: {GtLlmMessageStyler new
							threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new).
						GtLlmThreadMessageStyler new annotations: self annotations});
		text: [ self textBlock ]
]
