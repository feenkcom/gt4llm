Extension { #name : #Object }

{ #category : #'*Gt4LlmCore' }
Object >> addContentOneLineSummaryTo: aWriteStream [
	self gtDisplayOn: aWriteStream
]

{ #category : #'*Gt4LlmCore' }
Object >> contentOneLineMultiLabelSummaryWith: aBuilder [
	aBuilder newTextFromStringStream: [ :aWriteStream | 
		self addContentOneLineSummaryTo: aWriteStream ]
]

{ #category : #'*Gt4LlmCore' }
Object >> gtActionObjectChatFor: anAction [
	<gtAction>
	| chatBlock |
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].
	chatBlock := [ | c storedObjectId storeObject |
		c := GtL gt.
		storedObjectId := c addNewObject: self reasonString: 'Initial object'.
		storeObject := c objectStorage objectAt: storedObjectId.
		c
			pageObjectExplanation: (LePage new
					title: 'Objects';
					addSnippet: (LeTextSnippet
							string: 'Relate the conversation and actions primarily to the objects from the object storage. Place particular attention to the initial object, also attached to the first message. Use the object tools to explore. When executing code, do not guess, start from objects from object storage. Pass the object ids as bindings in Smalltalk code evaluation if needed.');
					yourself);
			sendWith: [ :m | 
				m
					addInputMagritteObject: (GtLObjectStorageValueResult new
								objectId: storedObjectId;
								object: self;
								objectValue: (GtLSerializedObjectValue fromObject: self))
						named: 'Initial object';
					markdown: 'Describe the object' ].
		c ].
	^ anAction button
		icon: BrGlamorousVectorIcons chat;
		tooltip: 'Chat about this object';
		target: GtPhlowObjectContextMenuTarget;
		menuItemGroup: BrMenuItemGroupConfiguration default;
		menuItemPreview: [ self gtDisplayText ];
		action: [ :button | button phlow spawnObject: chatBlock value ];
		primaryModifierAction: [ :aButton | 
				BlSpace new
					withCommonSettings;
					objectInPager: chatBlock value;
					showFrom: aButton ]
			mouseCursor: BlCopyCursor new
]
