Trait {
	#name : #TGtActionMessage,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
TGtActionMessage >> actionModel [
	^ (self chat tutor actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self) ifNotNil: #actionModel ]
				ifFalse: [ nil ] ]
]

{ #category : #'as yet unclassified' }
TGtActionMessage >> contentSummary [
	^ self action
]

{ #category : #'as yet unclassified' }
TGtActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
TGtActionMessage >> gtPromoteToExampleActionFor: anAction [
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Promote example';
		content: [ :aButton | 
			| action example |
			action := self chat tutor actionNamed: self action.
			example := GtLlmTutorActionExample new
					input: self ancestor contentJson;
					output: self contentJson.
			action addExample: example.
			action persist.
			example asGtMagritteViewModel asElement ]
]

{ #category : #'as yet unclassified' }
TGtActionMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
