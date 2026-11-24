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
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].

	^ anAction dropdown
		icon: BrGlamorousVectorIcons chat;
		tooltip: 'Chat about this object';
		target: GtPhlowObjectContextMenuTarget;
		addTarget: GtCoderClassTarget;
		menuItemGroup: BrMenuItemGroupConfiguration default;
		content: [:aButton | (GtLChatWithObjectDropdownContentStencil new
						anchor: aButton;
						object: self)]
]

{ #category : #'*Gt4LlmCore' }
Object >> gtViewDefinedLlmDataViewsFor: aView [
	<gtView>
	
	(GtLDataViewsCollector defaultPragmaNames anySatisfy: [ :pragmaName |
		(Pragma allNamed: pragmaName from: self class to: ProtoObject) notEmpty ])
			ifFalse: [ ^ aView empty ].
	
	^ aView columnedList
			title: 'LLM views';
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
