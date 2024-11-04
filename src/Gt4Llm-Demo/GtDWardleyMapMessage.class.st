Class {
	#name : #GtDWardleyMapMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4Llm-Demo'
}

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> diffedModel [
	| oldModel newModel |
	oldModel := (GtWardleyMapParser parse: self pipeline instance contentValue)
			asWardleyMapModel.
	newModel := (GtWardleyMapParser parse: self wardleyMap) asWardleyMapModel.
	^ GtWardleyMapUtility addModelAsPropositionsFrom: oldModel to: newModel withPropositionBlock: #beReadOnly
]

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> gtWardleyMapFor: aView [
	<gtView>
	<gtLlmMessageView>
	| view |
	self wardleyMap isEmptyOrNil ifTrue: [ ^ aView empty ].

	view := aView explicit
			title: 'Wardley map';
			priority: 1;
			stencil: [ GtWardleyMapElement new
					wardleyMapViewModel: (GtWardleyMapViewModel new wardleyMapModel: self diffedModel);
					vExact: 500 ].
	self isAssistantRole
		ifTrue: [ view
				actionButtonIcon: BrGlamorousVectorIcons accept
				tooltip: 'Save model'
				action: [ self chat pipeline instance updateContent: self wardleyMap ] ].
	^ view
]

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> gtWardleyMapScriptFor: aView [
	<gtView>
	<gtLlmMessageView>
	self wardleyMap isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Wardley map script';
		priority: 2;
		text: [ self wardleyMap ];
		styler: GtWardleyMapParser gtStyler
]

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> wardleyMap [
	^ self contentJson at: 'Wardley map'
]
