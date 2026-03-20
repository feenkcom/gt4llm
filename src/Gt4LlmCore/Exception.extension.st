Extension { #name : #Exception }

{ #category : #'*Gt4LlmCore' }
Exception >> gtActionStartChatOnExceptionWithObjectsFor: anAction [
	<gtAction>
	
	^ anAction button
		priority: 5.1;
		target: GtLDebuggerChatActionsTarget;
		label: 'Analyse exception (live)';
		action: [ :aButton | 
			| chat serializedObject |
			chat := GtL gtChat.
			serializedObject := NeoJSONObject new
				at: #exception put: (GtLValueSerializer new
					serializeValue: self);
				at: #stacktrace put: (self signalerContext
					ifNotNil: [ :anInterruptedContext | 
						anInterruptedContext stack
							ifNotNil: [ :aStack | 
								(aStack collect: [ :each | 
									| serializedFrame|
									serializedFrame := {
										 'value' -> each gtDisplayString
									} asDictionary.
									chat objectStorage ifNotNil: [ :aStorage |
										| objectId |
										objectId := aStorage addNewObject: self.
										serializedFrame at: 'objectId' put: objectId ]. 
									serializedFrame ]) asArray ] ]);
				yourself.
			chat objectStorage ifNotNil: [ :aStorage |
				| objectId |
				objectId := aStorage addNewObject: self.
				serializedObject at: 'objectId' put: objectId ]. 
			chat sendWith: [ :aMessage |
				aMessage 
					markdown: ('Analyse this exception and propose a possible fix.');
					addInputModel: (GtLJsonSchemaBasedModel new
						name: 'Exception';
						model: serializedObject;
						schema: (NeoJSONSchema new 
							json: (NeoJSONObject fromString: '{"type":"object"}' ))) ].
			aButton phlow spawnObject: chat ]
]

{ #category : #'*Gt4LlmCore' }
Exception >> gtActionStartChatOnPlainExceptionFor: anAction [
	<gtAction>
	
	^ anAction button
		priority: 5;
		target: GtLDebuggerChatActionsTarget;
		label: 'Analyse exception (static)';
		action: [ :aButton | 
			| chat |
			chat := GtL gtChat.
			chat sendWith: [ :aMessage |
				aMessage 
					markdown: ('Analyse this exception and propose a possible fix.');
					addInputModel: (GtLJsonSchemaBasedModel new
						name: 'Exception';
						model: self serializeToLlmJsonObject;
						schema: (NeoJSONSchema new 
							json: (NeoJSONObject fromString: '{"type":"object"}' ))) ].
			aButton phlow spawnObject: chat ]
]

{ #category : #'*Gt4LlmCore' }
Exception >> llmDataViewFor: aDataView [
	<gtLlmDataView>
	
	^aDataView jsonData
			title: 'Exception properties';
			data: [ 
				GtLValueSerializer new
					serializeException: self  ]
]

{ #category : #'*Gt4LlmCore' }
Exception >> serializeToLlmJsonObject [
	^ GtLValueSerializer new
			serializeException: self
]

{ #category : #'*Gt4LlmCore' }
Exception >> serializeToLlmResponseImages [
	^{}
]

{ #category : #'*Gt4LlmCore' }
Exception >> serializeToOpenAIResponseImages [
	^{}
]

{ #category : #'*Gt4LlmCore' }
Exception >> serializeToOpenAIResponseOutput [
	^ self serializeToLlmJsonObject
]
