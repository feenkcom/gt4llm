Extension { #name : #Exception }

{ #category : #'*Gt4LlmCore' }
Exception >> gtActionStartChatOnExceptionWithObjectsFor: anAction [
	<gtAction>
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].

	^ anAction button
		priority: 5.1;
		target: GtDebuggerContextMenuTarget;
		addTarget: GtPhlowObjectContextMenuTarget;
		icon: BrGlamorousVectorIcons chat;
		label: 'Analyse exception (live)';
		menuItemGroup: BrMenuItemGroupConfiguration default;
		action: [ :aButton | 
			| chat serializedObject |
			chat := GtL gtChat.
			serializedObject := NeoJSONObject new
					at: #exception put: (GtLValueSerializer new serializeValue: self);
					at: #stacktrace
						put: (self signalerContext
								ifNotNil: [ :anInterruptedContext | 
									anInterruptedContext stack
										ifNotNil: [ :aStack | 
											(aStack
												collect: [ :each | 
													| serializedFrame |
													serializedFrame := {'value' -> each gtDisplayString} asDictionary.
													chat objectStorage
														ifNotNil: [ :aStorage | 
															| objectId |
															objectId := aStorage addNewObject: each.
															serializedFrame at: 'objectId' put: objectId ].
													serializedFrame ]) asArray ] ]);
					yourself.
			chat objectStorage
				ifNotNil: [ :aStorage | 
					| objectId |
					objectId := aStorage addNewObject: self.
					serializedObject at: 'objectId' put: objectId ].
			chat
				sendWith: [ :aMessage | 
					aMessage
						markdown: 'Analyse this exception and propose a possible fix.';
						addInputModel: (GtLJsonSchemaBasedModel new
								name: 'Exception';
								model: serializedObject;
								schema: (NeoJSONSchema new json: (NeoJSONObject fromString: '{"type":"object"}'))) ].
			aButton phlow spawnObject: chat ]
]

{ #category : #'*Gt4LlmCore' }
Exception >> gtActionStartChatOnPlainExceptionFor: anAction [
	<gtAction>
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].

	^ anAction button
		priority: 5;
		target: GtDebuggerContextMenuTarget;
		addTarget: GtPhlowObjectContextMenuTarget;
		icon: BrGlamorousVectorIcons chat;
		label: 'Analyse exception (static)';
		menuItemGroup: BrMenuItemGroupConfiguration default;
		action: [ :aButton | 
			| chat |
			chat := GtL gtChat.
			chat
				sendWith: [  "The exception is described by its LLM data views (see #llmDataViewFor:)":aMessage | 
					aMessage
						markdown: 'Analyse this exception and propose a possible fix.';
						addWrappedObject: self named: 'Exception' ].
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
