Class {
	#name : #GtDWardleyMapMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4Llm-Demo'
}

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> diffedModel [
	| oldModel newModel diffedModel |
	oldModel := (GtWardleyMapParser parse: self pipeline instance contentValue)
			asWardleyMapModel.
	newModel := (GtWardleyMapParser parse: self wardleyMap) asWardleyMapModel.
	diffedModel := GtWardleyMapUtility
			addModelAsPropositionsFrom: oldModel
			to: newModel
			withPropositionBlock: #beReadOnly.

	self renameCodeBlock isEmptyOrNil
		ifFalse: [ | aJson |
			aJson := STONJSON fromString: self renameCodeBlock.
			aJson
				associationsDo: [ :aPair | 
					diffedModel
						nodeWithName: aPair key
						ifFound: [ :aNode | 
							aNode
								addWardleyMapDecoratorModel: (GtWardleyMapRenameProposition new options: aPair value) ]
						ifNone: [  ] ] ].

	^ diffedModel
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
				action: [ self chat pipeline instance updateContent: self wardleyMapWithRenames ] ].
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
GtDWardleyMapMessage >> renameCodeBlock [
	^ self contentJson at: 'Rename' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> wardleyMap [
	^ self contentJson at: 'Wardley map'
]

{ #category : #'as yet unclassified' }
GtDWardleyMapMessage >> wardleyMapWithRenames [
	| wardleyMap |
	wardleyMap := (GtWardleyMapParser parse: self wardleyMap) asWardleyMapModel.


	self renameCodeBlock isEmptyOrNil
		ifFalse: [ | aJson |
			aJson := STONJSON fromString: self renameCodeBlock.
			aJson
				associationsDo: [ :aPair | 
					wardleyMap
						nodeWithName: aPair key
						ifFound: [ :aNode | 
							aNode
								addWardleyMapDecoratorModel: (GtWardleyMapRenameProposition new options: aPair value) ]
						ifNone: [  ] ] ].

	^ wardleyMap
]
