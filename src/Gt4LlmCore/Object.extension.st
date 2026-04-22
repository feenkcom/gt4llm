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
							string: 'Relate the conversation primarily to the initial object, also attached to the first message.');
					yourself);
			sendWith: [ :m | 
				m
					markdown: 'Describe the object';
					addPlainInputObject: self
						withId: storedObjectId
						named: 'Initial object' ].
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

{ #category : #'*Gt4LlmCore' }
Object >> gtViewDefinedLlmDataViewsFor: aView [
	<gtView>
	
	(GtLDataViewsCollector defaultPragmaNames anySatisfy: [ :pragmaName |
		(Pragma allNamed: pragmaName from: self class to: ProtoObject) notEmpty ])
			ifFalse: [ ^ aView empty ].
	
	^ aView columnedList
			title: 'LLM data views';
			priority: 120;
			items: [ self llmDataViewsInContext:  GtLDataViewContext new ];
			column: 'Title' text: [ :aDataView | aDataView title ifNil: [ 'Untitled' ] ];
			column: 'Priority' 
				text: [ :aDataView | aDataView priority ifNil: [ '-' ] ]
				width: 200;
			column: 'Type'
			 	text: [ :aDataView | aDataView class name ]
			 	width: 200
]
