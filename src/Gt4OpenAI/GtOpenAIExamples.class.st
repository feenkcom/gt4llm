Class {
	#name : #GtOpenAIExamples,
	#superclass : #Object,
	#category : #'Gt4OpenAI-Examples'
}

{ #category : #'examples - messages' }
GtOpenAIExamples >> basicExpandableThreadMessageElement [
	<gtExample>
	| anElement |
	anElement := GtOpenAIExpandableThreadMessageElement new.

	self assert: anElement threadMessageViewModel isNil.

	^ anElement
]

{ #category : #'examples - failure message' }
GtOpenAIExamples >> basicFailureThreadMessage [
	<gtExample>
	| aMessage |
	aMessage := GtOpenAIFailureThreadMessage new.

	self assert: aMessage failureText isNil.
	self assert: aMessage contentText isNotNil.
	self assert: aMessage contentText isEmpty.

	^ aMessage
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> basicThreadMessage [
	<gtExample>
	| aMessage |
	aMessage := GtOpenAIThreadMessage new.

	^ aMessage
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> basicThreadMessageViewModel [
	<gtExample>
	| aViewModel |
	aViewModel := GtOpenAIThreadMessageViewModel new.

	self assert: aViewModel threadMessage isNil.

	^ aViewModel
]

{ #category : #'examples - json' }
GtOpenAIExamples >> definedClassesJsonQuestion [
	^ NeoJSONObject
		fromString: '{
	"id" : "msg_Xf7FnGmqdgpZslLXMmYBcZ9k",
	"object" : "thread.message",
	"created_at" : 1708606631,
	"assistant_id" : null,
	"thread_id" : "thread_A5WQxnoQ7zgwLUdbebGaZtgl",
	"run_id" : null,
	"role" : "user",
	"content" : [
		{
			"type" : "text",
			"text" : {
				"value" : "Write me a snippet that lists all currently defined classes in the image.",
				"annotations" : [ ]
			}
		}
	],
	"file_ids" : [ ],
	"metadata" : { }
}'
]

{ #category : #'examples - json' }
GtOpenAIExamples >> definedClassesJsonResponse [
	^ NeoJSONObject
		fromString: '{
	"id" : "msg_8ZGngDenmtdcnGCKxBbjh7DH",
	"object" : "thread.message",
	"created_at" : 1708606633,
	"assistant_id" : "asst_qw7rlEo5TMj9kMtJ7d4XkbRL",
	"thread_id" : "thread_A5WQxnoQ7zgwLUdbebGaZtgl",
	"run_id" : "run_Uz4xgTyzjTmZgwOtaziSMhJQ",
	"role" : "assistant",
	"content" : [
		{
			"type" : "text",
			"text" : {
				"value" : "```smalltalk\nSmalltalk globals classNames asSortedCollection\n```",
				"annotations" : [ ]
			}
		}
	],
	"file_ids" : [ ],
	"metadata" : { }
}'
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> definedClassesMessageQuestion [
	<gtExample>
	| aJson |
	aJson := self definedClassesJsonQuestion.
	^ GtOpenAIThreadMessage from: aJson
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> definedClassesMessageResponse [
	<gtExample>
	| aJson |
	aJson := self definedClassesJsonResponse.
	^ GtOpenAIThreadMessage from: aJson
]

{ #category : #'examples - failure message' }
GtOpenAIExamples >> failureThreadMessage [
	<gtExample>
	| aMessage aDescription |
	aMessage := self basicFailureThreadMessage.
	aDescription := 'Sorry, something went wrong'.
	aMessage failureText: aDescription.
	
	self assert: aMessage failureText isNotNil.
	self assert: aMessage contentText isNotNil.
	self assert: aMessage contentText equals: aDescription.

	^ aMessage
]

{ #category : #'examples - failure message' }
GtOpenAIExamples >> failureThreadMessageElement [
	<gtExample>
	| aViewModel anElement |
	
	aViewModel := self failureThreadMessageViewModel.
	anElement := aViewModel elementClass newForChatList.
	anElement threadMessageViewModel: aViewModel.

	self assert: anElement threadMessageViewModel equals: aViewModel.

	^ anElement
]

{ #category : #'examples - failure message' }
GtOpenAIExamples >> failureThreadMessageViewModel [
	<gtExample>
	| aMessage aViewModel |
	
	aViewModel := self basicThreadMessageViewModel.
	aMessage := self failureThreadMessage.
	aViewModel threadMessage: aMessage.

	self assert: aViewModel threadMessage equals: aMessage.	
	self assert: aViewModel contentText isNotNil.
	self assert: aMessage contentText equals: aMessage contentText.
	self assert: aViewModel isFailure.

	^ aViewModel
]

{ #category : #'examples - json' }
GtOpenAIExamples >> fractionPhlowViewJsonQuestion [
	^ NeoJSONObject
		fromString: '{
	"id" : "msg_SsimeoEvc6Tyn3KqmBnKUfOQ",
	"object" : "thread.message",
	"created_at" : 1708607389,
	"assistant_id" : null,
	"thread_id" : "thread_A5WQxnoQ7zgwLUdbebGaZtgl",
	"run_id" : null,
	"role" : "user",
	"content" : [
		{
			"type" : "text",
			"text" : {
				"value" : "Create a Phlow view for Fraction that displays numerator and denominator.",
				"annotations" : [ ]
			}
		}
	],
	"file_ids" : [ ],
	"metadata" : { }
}'
]

{ #category : #'examples - json' }
GtOpenAIExamples >> fractionPhlowViewJsonResponse [
	^ NeoJSONObject
		fromString: '{
	"id" : "msg_ChUGxGcg07FvyzaigUA5kLJa",
	"object" : "thread.message",
	"created_at" : 1708607392,
	"assistant_id" : "asst_qw7rlEo5TMj9kMtJ7d4XkbRL",
	"thread_id" : "thread_A5WQxnoQ7zgwLUdbebGaZtgl",
	"run_id" : "run_RTVkhYTCiCfoxAnarHXHuCz4",
	"role" : "assistant",
	"content" : [
		{
			"type" : "text",
			"text" : {
				"value" : "```smalltalk-method\nFraction\ngtNumeratorAndDenominatorFor: aView\n\t<gtView>\n\t^ aView columnedList\n\t\ttitle: ''Numerator and Denominator'';\n\t\tpriority: 1;\n\t\titems: { (''Numerator'' -> self numerator). (''Denominator'' -> self denominator) };\n\t\tcolumn: ''Component'' text: [:each | each key];\n\t\tcolumn: ''Value'' text: [:each | each value]\n```",
				"annotations" : [ ]
			}
		}
	],
	"file_ids" : [ ],
	"metadata" : { }
}'
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> fractionPhlowViewMessageQuestion [
	<gtExample>
	| aJson |
	aJson := self fractionPhlowViewJsonQuestion.
	^ GtOpenAIThreadMessage from: aJson
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> fractionPhlowViewMessageResponse [
	<gtExample>
	| aJson |
	aJson := self fractionPhlowViewJsonResponse.
	^ GtOpenAIThreadMessage from: aJson
]

{ #category : #'examples - json' }
GtOpenAIExamples >> phlowDescriptionJsonQuestion [
	^ NeoJSONObject
		fromString: '{
	"id" : "msg_mAd5dtIrxIiEtP8FKgSy3cuN",
	"object" : "thread.message",
	"created_at" : 1708606661,
	"assistant_id" : null,
	"thread_id" : "thread_A5WQxnoQ7zgwLUdbebGaZtgl",
	"run_id" : null,
	"role" : "user",
	"content" : [
		{
			"type" : "text",
			"text" : {
				"value" : "Tell me about Phlow based on the files that you have access to.",
				"annotations" : [ ]
			}
		}
	],
	"file_ids" : [ ],
	"metadata" : { }
}'
]

{ #category : #'examples - json' }
GtOpenAIExamples >> phlowDescriptionJsonResponse [
	^ NeoJSONObject
		fromString: '{
	"id" : "msg_7QRL9CfPUDj1aIaFWr9rursK",
	"object" : "thread.message",
	"created_at" : 1708606666,
	"assistant_id" : "asst_qw7rlEo5TMj9kMtJ7d4XkbRL",
	"thread_id" : "thread_A5WQxnoQ7zgwLUdbebGaZtgl",
	"run_id" : "run_uFfn8eaJnZKKVvOik08W6Zsk",
	"role" : "assistant",
	"content" : [
		{
			"type" : "text",
			"text" : {
				"value" : "Phlow in Glamorous Toolkit is a framework designed for building interactive and flexible user interface views, primarily within the GT Inspector. Based on the examples observed from the provided file, Phlow allows developers to create rich, informative views that can include lists, trees, and custom actions, shown through various gtView methods. Here are some insights into its functionalities based on the defined methods:\n\n- **Columned Lists**: Views can be organized as columned lists, where each row represents an item with multiple attributes displayed across columns. For instance, `AWebLinkGroup>>gtOverviewFor:` creates a columned list to show an overview of web link groups, where each item consists of key-value pairs such as attribute and value. It supports actions like buttons and updates when certain events are triggered.\n\n- **Mondrian Visualizations**: Phlow supports mondrian visualizations for structuring and presenting data graphically. For example, `AWebPage>>gtMapFor:` uses a mondrian view to present a map of web pages, offering a spatially organized representation of related data.\n\n- **Forwarding Views**: It enables forwarding to other views or objects. This is useful for creating views that link or navigate to other data representations within the inspector. For example, `AWebPage>>gtContentsFor:` forwards to another view that displays the contents of a web page.\n\n- **Action Buttons and Updates**: Phlow views can include interactive elements like action buttons. These buttons can perform various actions, such as spawning new objects in the Phlow or triggering updates. This is exemplified in `AbstractFileReference>>gtPathFor:`, which includes action buttons for making directories or empty files.\n\n- **View Prioritization**: Views can be assigned priorities to control their order of appearance in the inspection context. This allows for a logical grouping and sequencing of information presented to the user.\n\nOverall, Phlow facilitates the creation of modular, interactive views that enhance exploration and manipulation of objects within the Glamorous Toolkit environment. It leverages Smalltalk''s expressive power to enable dynamic and context-sensitive information visualization, which can significantly improve the development and debugging experience.",
				"annotations" : [ ]
			}
		}
	],
	"file_ids" : [ ],
	"metadata" : { }
}'
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> phlowDescriptionMessageExpandableElementQuestion [
	<gtExample>
	| aViewModel anElement |
	anElement := self basicExpandableThreadMessageElement.
	aViewModel := self phlowDescriptionMessageViewModelQuestion.
	anElement threadMessageViewModel: aViewModel.

	^ anElement
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> phlowDescriptionMessageExpandableElementResponse [
	<gtExample>
	| aViewModel anElement |
	anElement := self basicExpandableThreadMessageElement.
	aViewModel := self phlowDescriptionMessageViewModelResponse.
	anElement threadMessageViewModel: aViewModel.

	^ anElement
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> phlowDescriptionMessageExpandableElementResponse_collapsed [
	<gtExample>
	| aViewModel anElement |
	anElement := self basicExpandableThreadMessageElement.
	aViewModel := self phlowDescriptionMessageViewModelResponse.
	aViewModel isExpanded: false.
	anElement threadMessageViewModel: aViewModel.

	^ anElement
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> phlowDescriptionMessageQuestion [
	<gtExample>
	| aJson |
	aJson := self phlowDescriptionJsonQuestion.
	^ GtOpenAIThreadMessage from: aJson
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> phlowDescriptionMessageResponse [
	<gtExample>
	| aJson |
	aJson := self phlowDescriptionJsonResponse.
	^ GtOpenAIThreadMessage from: aJson
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> phlowDescriptionMessageViewModelQuestion [
	<gtExample>
	| aViewModel aMessage |
	aViewModel := self basicThreadMessageViewModel.
	aMessage := self phlowDescriptionMessageQuestion.
	aViewModel threadMessage: aMessage.

	^ aViewModel
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> phlowDescriptionMessageViewModelResponse [
	<gtExample>
	| aViewModel aMessage |
	aViewModel := self basicThreadMessageViewModel.
	aMessage := self phlowDescriptionMessageResponse.
	aViewModel threadMessage: aMessage.

	^ aViewModel
]

{ #category : #'examples - json' }
GtOpenAIExamples >> veryLongJsonQuestion [
	^ NeoJSONObject
		fromString: '{"id":"msg_ARdhrrOJeadhJz47MukYbugP","object":"thread.message","created_at":1708619318,"assistant_id":null,"thread_id":"thread_C9gW2spaxcCx8uxo4paGRXD0","run_id":null,"role":"user","content":[{"type":"text","text":{"value":"The last script had a problem: \r```text\rEncountered an error in the view: Message not understood: BlFont class >> #family:size:\rTrace:\rMessageNotUnderstood(Exception)>>signal\rBlFont class(Object)>>doesNotUnderstand: #family:size:\r[ \n            | fractionRepresentation |\n            fractionRepresentation := BrLabel new\n                text: self numerator printString, '' / '', self denominator printString.\n            fractionRepresentation\n                font: (BlFont family: ''Arial'' size: 16);\n                background: Color lightBlue;\n                borderColor: Color gray;\n                borderWidth: 1;\n                padding: (BlInsets all: 5).\n            BlElement new\n                addChild: fractionRepresentation ] in Fraction>>gtSimpleViewFor:\rFullBlockClosure(BlockClosure)>>gtValueWithArgs:\rBrStencilValuableExecutor>>execute\rBrStencilBuilder>>build\rBrStencilBuilder>>asElement\r[ stencilBuilder asElement ] in GtPhlowExplicitView>>asElementDo:\rFullBlockClosure(BlockClosure)>>on:do:\rGtPhlowExplicitView(GtPhlowView)>>performBlock:onException:\rGtPhlowExplicitView(GtPhlowView)>>performBlock:onExceptionErrorElement:\rGtPhlowExplicitView>>asElementDo:\r[ | createdView |\r\tcreatedView := self instance perform: self view selector withArguments: {aView}.\r\tcreatedView\r\t\tasElementDo: [ :anElement | \r\t\t\t| scripter listOfErrors |\r\t\t\tscripter := BlScripter new.\r\t\t\tscripter element: anElement.\r\t\t\tscripter elementWithoutParent.\r\t\t\tlistOfErrors := (anElement query // GtPhlowExceptionId) all\r\t\t\t\t\t, (anElement id = GtPhlowExceptionId asBlocElementId ifTrue: [ {anElement} ] ifFalse: [ {} ])\r\t\t\t\t\tcollect: [ :anErrorElement | anErrorElement userData at: #exception ].\r\t\t\tlistOfErrors\r\t\t\t\tifNotEmpty: [ :aList | \r\t\t\t\t\t^ aView list\r\t\t\t\t\t\ttitle: ''View errors'';\r\t\t\t\t\t\tpriority: 1;\r\t\t\t\t\t\titems: aList;\r\t\t\t\t\t\tactionButtonIcon: BrGlamorousVectorIcons play\r\t\t\t\t\t\t\ttooltip: ''Send to chat''\r\t\t\t\t\t\t\taction: [ self threadMessage chat\r\t\t\t\t\t\t\t\t\tsendMessage: (GtLlmCheckerError new\r\t\t\t\t\t\t\t\t\t\t\tchecker: self;\r\t\t\t\t\t\t\t\t\t\t\tcontent: aList;\r\t\t\t\t\t\t\t\t\t\t\tcontentString: (self createErrorString: aList first)) asString ] ] ].\r\t^ createdView ] in GtLlmViewObject>>gtViewFor:\rFullBlockClosure(BlockClosure)>>on:do:\rGtLlmViewObject>>gtViewFor:\rGtPhlowEmptyView(GtPhlowView)>>basicOn:perform:withArguments:\r[ \r\t\t\tself basicOn: anObject perform: aMessageSymbol withArguments: aCollectionOfArguments\r\t] in GtPhlowEmptyView(GtPhlowView)>>on:perform:withArguments:\rFullBlockClosure(BlockClosure)>>on:do:\rGtPhlowEmptyView(GtPhlowView)>>on:perform:withArguments:\rGtPhlowEmptyView(GtPhlowView)>>on:perform:withSomeArguments:\rGtPhlowEmptyView(GtPhlowView)>>on:perform:withContext:\r[ :eachPragma | \r\t\t\t| aView |\r\t\t\taView := GtPhlowView empty \r\t\t\t\ton: self object \r\t\t\t\tperform: eachPragma methodSelector\r\t\t\t\twithContext: self context.\r\t\t\tself object gtActions do: [ :eachAction | \r\t\t\t\t(eachAction target isForViewDefinedIn: eachPragma methodSelector) ifTrue: [ \r\t\t\t\t\taView addPhlowAction: eachAction ] ].\r\t\t\taView ] in GtPhlowViewsCollector>>collect\rOrderedCollection>>collect:\rGtPhlowViewsCollector>>collect\rGtLlmViewObject(ProtoObject)>>gtViewsInContext:\rGtPhlowLabelledViewBuilder(GtPhlowCompositeViewBuilder)>>views\rGtPhlowLabelledViewBuilder(GtPhlowCompositeViewBuilder)>>buildView\rGtPhlowLabelledViewBuilder>>buildView\rGtPhlowLabelledViewBuilder(GtPhlowViewBuilder)>>build\rGtLlmViewObject(ProtoObject)>>gtViewsFor:inContext:\rGtLlmViewObject(ProtoObject)>>gtViewsFor:\rGtPhlowEmptyView(GtPhlowView)>>basicOn:perform:withArguments:\r[ \r\t\t\tself basicOn: anObject perform: aMessageSymbol withArguments: aCollectionOfArguments\r\t] in GtPhlowEmptyView(GtPhlowView)>>on:perform:withArguments:\rFullBlockClosure(BlockClosure)>>on:do:\rGtPhlowEmptyView(GtPhlowView)>>on:perform:withArguments:\rGtPhlowEmptyView(GtPhlowView)>>on:perform:withSomeArguments:\rGtPhlowEmptyView(GtPhlowView)>>on:perform:\rGtInspectorObject>>view\rGtInspectorObject>>asElementDo:\rGtInspectorContentElement>>updateView\rGtInspectorContentElement>>onObjectHolderChanged\rGtInspectorContentElement(GtInspectorObjectElement)>>objectHolder:\rGtInspector>>onObjectHolderChanged\rGtInspector(GtInspectorObjectElement)>>objectHolder:\rGtInspectorTool>>asElementDo:\rGtInspectorTool(GtPhlowTool)>>asToolElementDo:\rGtPagerPageSelectionContext>>asElementDo:\rGtPager>>spawn:\rGtPagerHolder>>spawn:\r[ :anEvent | \r\t\t\tanEvent consumed: true.\r\t\t\taTriangleElement visibility: BlVisibility visible.\r\t\t\tself pagerHolder spawn: (self createSelectionContextFromEvent: anEvent).] in GtPagerPageEmbellisher>>createNextPageButtonOnContentWrapper:\rFullBlockClosure(BlockClosure)>>cull:\rBlEventHandler>>handleEvent:\rBlHandlerAnnouncementSubscription>>deliver:\r[ subscription deliver: anAnnouncement ] in SubscriptionRegistry>>deliver:to:startingAt:\rFullBlockClosure(BlockClosure)>>ifCurtailed:\rSubscriptionRegistry>>deliver:to:startingAt:\rSubscriptionRegistry>>deliver:to:\rSubscriptionRegistry>>deliver:\rAnnouncer>>announce:\rBlHandlerAnnouncerRegistry>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchBubblingEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBrButton(BlElement)>>fireEvent:\rGtPhlowElementContext>>spawnTool:withDestination:\rGtPhlowElementContext>>spawnTool:\rGtPhlowElementContext>>spawnObject:\rGtLlmMessageStyler>>evaluateMethodBlock:expanded:from:isReplace:\r[ :aWidget :aButtonModel | \r\t\t\t\t\t\t\tself\r\t\t\t\t\t\t\t\tevaluateMethodBlock: aCodeNode\r\t\t\t\t\t\t\t\texpanded: true\r\t\t\t\t\t\t\t\tfrom: aWidget\r\t\t\t\t\t\t\t\tisReplace: isReplace ] in [ GtButtonStencil new\r\t\t\t\t\t\ticon: BrGlamorousVectorIcons playinspect;\r\t\t\t\t\t\ttooltip: tooltip;\r\t\t\t\t\t\taction: [ :aWidget :aButtonModel | \r\t\t\t\t\t\t\tself\r\t\t\t\t\t\t\t\tevaluateMethodBlock: aCodeNode\r\t\t\t\t\t\t\t\texpanded: true\r\t\t\t\t\t\t\t\tfrom: aWidget\r\t\t\t\t\t\t\t\tisReplace: isReplace ] ] in GtLlmMessageStyler>>styleSmalltalkMethod:\rFullBlockClosure(BlockClosure)>>gtValueWithArgs:\rBrButtonModel>>clickEvent:\r[ :anEvent | (self hasModifiers: anEvent) ifFalse: [ self clickEvent: anEvent ] ] in BrButtonModel>>initializeListeners\rFullBlockClosure(BlockClosure)>>cull:\rBlEventHandler>>handleEvent:\r[\r\t\tanEvent forwardingTarget: self eventTarget.\r\t\tself eventHandler handleEvent: anEvent ] in BlEventForwarder>>handleEvent:\rFullBlockClosure(BlockClosure)>>ensure:\rBlEventForwarder>>handleEvent:\rBlHandlerAnnouncementSubscription>>deliver:\r[ subscription deliver: anAnnouncement ] in SubscriptionRegistry>>deliver:to:startingAt:\rFullBlockClosure(BlockClosure)>>ifCurtailed:\rSubscriptionRegistry>>deliver:to:startingAt:\rSubscriptionRegistry>>deliver:to:\rSubscriptionRegistry>>deliver:\rAnnouncer>>announce:\rBlHandlerAnnouncerRegistry>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchArrivedEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlElementEventDispatcher(BlBubblingEventDispatcher)>>dispatchEvent:next:\rBlEventDispatcherChain>>dispatchEvent:\rBlEvent class>>fireEvent:target:\rBlEvent class>>fireEvent:\rBlMouseProcessor(BlBaseEventProcessor)>>fireEvent:\rBlMouseProcessor>>processMouseUp:\rBlMouseProcessor>>handleMouseUp:\rBlSpaceEventListener>>mouseUpEvent:\rBlMouseUpEvent>>sendTo:\rBlSpaceEventListener(BlEventListener)>>handleEvent:\rBlSpaceEventListener>>handleEvent:\rBlHandlerAnnouncementSubscription>>deliver:\r[ subscription deliver: anAnnouncement ] in SubscriptionRegistry>>deliver:to:startingAt:\rFullBlockClosure(BlockClosure)>>ifCurtailed:\rSubscriptionRegistry>>deliver:to:startingAt:\rSubscriptionRegistry>>deliver:to:\rSubscriptionRegistry>>deliver:\rAnnouncer>>announce:\rBlHandlerAnnouncerRegistry>>dispatchEvent:\rBlDirectEventDispatcher>>dispatchEvent:next:\rBlDirectEventDispatcher(BlEventDispatcher)>>dispatchEvent:\r[\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] in [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ] in [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] in [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ] in [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ] in [ :theSpace |\r\t\t\t\"We must update focused element before processing events, otherwise keyboard events,\r\t\t\tfor example, will be handled by the wrong element\"\r\t\t\taSpace doUpdateFocus.\r\r\t\t\ttheSpace hostSpaceDo: [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ].\r\t\t\ttheSpace mouseProcessor generateEvents ] in BlSpaceFrameEventPhase>>runOn:\rFullBlockClosure(BlockClosure)>>cull:\rGtWorld(BlSpace)>>hostSpaceDo:ifAbsent:\rGtWorld(BlSpace)>>hostSpaceDo:\r[\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ] in [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] in [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ] in [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ] in [ :theSpace |\r\t\t\t\"We must update focused element before processing events, otherwise keyboard events,\r\t\t\tfor example, will be handled by the wrong element\"\r\t\t\taSpace doUpdateFocus.\r\r\t\t\ttheSpace hostSpaceDo: [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ].\r\t\t\ttheSpace mouseProcessor generateEvents ] in BlSpaceFrameEventPhase>>runOn:\rNullTelemetry>>time:during:\rBlSpaceTelemetry>>time:during:\rBlFrameTelemetry(BaseProcessTelemetry)>>time:during:\rBlFrameTelemetry class(BaseProcessTelemetry class)>>time:during:\r[ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] in [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ] in [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ] in [ :theSpace |\r\t\t\t\"We must update focused element before processing events, otherwise keyboard events,\r\t\t\tfor example, will be handled by the wrong element\"\r\t\t\taSpace doUpdateFocus.\r\r\t\t\ttheSpace hostSpaceDo: [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ].\r\t\t\ttheSpace mouseProcessor generateEvents ] in BlSpaceFrameEventPhase>>runOn:\rLinkedList>>do:\rBlHostEventFetcher>>fetchedEventsDo:\rBlGlutinHostSpace>>fetchedEventsDo:\r[ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ] in [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ] in [ :theSpace |\r\t\t\t\"We must update focused element before processing events, otherwise keyboard events,\r\t\t\tfor example, will be handled by the wrong element\"\r\t\t\taSpace doUpdateFocus.\r\r\t\t\ttheSpace hostSpaceDo: [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ].\r\t\t\ttheSpace mouseProcessor generateEvents ] in BlSpaceFrameEventPhase>>runOn:\rFullBlockClosure(BlockClosure)>>cull:\rGtWorld(BlSpace)>>hostSpaceDo:ifAbsent:\rGtWorld(BlSpace)>>hostSpaceDo:\r[ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ] in [ :theSpace |\r\t\t\t\"We must update focused element before processing events, otherwise keyboard events,\r\t\t\tfor example, will be handled by the wrong element\"\r\t\t\taSpace doUpdateFocus.\r\r\t\t\ttheSpace hostSpaceDo: [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ].\r\t\t\ttheSpace mouseProcessor generateEvents ] in BlSpaceFrameEventPhase>>runOn:\rFullBlockClosure(BlockClosure)>>cull:\rGtWorld(BlSpace)>>hostSpaceDo:ifAbsent:\rGtWorld(BlSpace)>>hostSpaceDo:\r[ :theSpace |\r\t\t\t\"We must update focused element before processing events, otherwise keyboard events,\r\t\t\tfor example, will be handled by the wrong element\"\r\t\t\taSpace doUpdateFocus.\r\r\t\t\ttheSpace hostSpaceDo: [ \r\t\t\t\t\"Process events enqueued by host space and dispatch them to the scene graph\"\r\r\t\t\t\ttheSpace eventRecorder onPulse.\r\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace |\r\t\t\t\t\taHostSpace fetchedEventsDo: [ :anEvent |\r\t\t\t\t\t\"we have to test for existance of the host space before handling each event because\r\t\t\t\t\tit is possible that a space is closed due to an event\"\r\t\t\t\t\t\r\t\t\t\t\tBlFrameTelemetry\r\t\t\t\t\t\ttime: [ ''Process event {1}'' format: { anEvent } ]\r\t\t\t\t\t\tduring: [\r\t\t\t\t\t\t\ttheSpace hostSpaceDo: [\r\t\t\t\t\t\t\t\ttheSpace eventRecorder record: anEvent.\r\t\t\t\t\t\t\t\ttheSpace eventDispatcher dispatchEvent: anEvent ] ]  ] ].\r\t\t\t\t\r\t\t\t\ttheSpace hostSpaceDo: [ :aHostSpace | aHostSpace generateEvents ] ].\r\t\t\ttheSpace mouseProcessor generateEvents ] in BlSpaceFrameEventPhase>>runOn:\rFullBlockClosure(BlockClosure)>>cull:\rGtWorld(BlSpace)>>dispatchTimeEvent:during:\rBlSpaceFrameEventPhase>>runOn:\r[ self currentPhase runOn: aSpace ] in BlSpaceFrame>>runCurrentPhaseOn:\rNullTelemetry>>time:during:\rBlSpaceTelemetry>>time:during:\rBlFrameTelemetry(BaseProcessTelemetry)>>time:during:\rBlFrameTelemetry class(BaseProcessTelemetry class)>>time:during:\rBlSpaceFrame>>runCurrentPhaseOn:\rBlSpaceFrame>>runOn:\r[ self frame runOn: self ] in [ BlFrameTelemetry soleInstance\r\t\t\t\t\t\t\tmessageTallyOn:  [ self frame runOn: self ] ] in BlSpace>>processPulse\rNullTelemetry>>profile:executing:as:\rBlSpaceTelemetry>>profile:executing:as:\rBlFrameTelemetry(BaseProcessTelemetry)>>profile:executing:as:\rBlFrameTelemetry(BaseProcessTelemetry)>>messageTallyOn:\r[ BlFrameTelemetry soleInstance\r\t\t\t\t\t\t\tmessageTallyOn:  [ self frame runOn: self ] ] in BlSpace>>processPulse\rNullTelemetry>>profile:executing:as:\rBlSpaceTelemetry>>profile:executing:as:\rBlFrameTelemetry(BaseProcessTelemetry)>>profile:executing:as:\rBlFrameTelemetry(BaseProcessTelemetry)>>beacon:as:on:\rBlFrameTelemetry(BaseProcessTelemetry)>>beacon:on:\r[\r\t\t\t\t\tBlFrameTelemetry soleInstance\r\t\t\t\t\t\tbeacon: BlRequestLayoutSignal, BlMarkElementNeedsPaintSignal, BlLostFocusSignal, BlGotFocusSignal, BlTextStylerRequestedSignal\r\t\t\t\t\t\ton: [ BlFrameTelemetry soleInstance\r\t\t\t\t\t\t\tmessageTallyOn:  [ self frame runOn: self ] ] ] in BlSpace>>processPulse\rNullTelemetry>>time:during:\rBlSpaceTelemetry>>time:during:\rBlFrameTelemetry(BaseProcessTelemetry)>>time:during:\rBlFrameTelemetry class(BaseProcessTelemetry class)>>time:during:\r[\r\t\t\tBlFrameTelemetry\r\t\t\t\treset;\r\t\t\t\ttime: [ ''Frame'' ]\r\t\t\t\tduring: [\r\t\t\t\t\tBlFrameTelemetry soleInstance\r\t\t\t\t\t\tbeacon: BlRequestLayoutSignal, BlMarkElementNeedsPaintSignal, BlLostFocusSignal, BlGotFocusSignal, BlTextStylerRequestedSignal\r\t\t\t\t\t\ton: [ BlFrameTelemetry soleInstance\r\t\t\t\t\t\t\tmessageTallyOn:  [ self frame runOn: self ] ] ];\r\t\t\t\tin: [ :t | t soleInstance snapshotSpace: self ];\r\t\t\t\temit ] in BlSpace>>processPulse\rFullBlockClosure(BlockClosure)>>ensure:\rBlFrameTelemetry class>>withSpace:andTelemetry:do:\rGtWorld(BlSpace)>>processPulse\rGtWorld(BlSpace)>>pulse\r[ :eachSpace | eachSpace pulse ] in BlParallelUniverse>>pulseSynchronously\rArray(SequenceableCollection)>>do:\rBlSpaceManager>>do:\r[\r\t\tself tryToRunDeferredActions.\r\t\tspaceManager do: [ :eachSpace | eachSpace pulse ]\r\t] in BlParallelUniverse>>pulseSynchronously\rFullBlockClosure(BlockClosure)>>ensure:\rBlParallelUniverse>>pulseSynchronously\r[\r\t\tself pulseSynchronously\r\t] in BlParallelUniverse>>pulse\rFullBlockClosure(BlockClosure)>>ensure:\rBlParallelUniverse>>pulse\rBlHostPulseLoop>>firePulse\r[\r\t\t[ self firePulse. loopProcess == Processor activeProcess. ] whileTrue\r\t] in BlHostPulseLoop>>createLoopTask\r[self value.\r\t\t\t\"IMPORTANT: Do not step over next line of code. See method comments for details\"\r\t\t\tProcessor terminateRealActive] in FullBlockClosure(BlockClosure)>>newProcess\r\r```","annotations":[]}}],"file_ids":[],"metadata":{}}'
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> veryLongMessageExpandableElementQuestion [
	<gtExample>
	| aViewModel anElement |
	anElement := self basicExpandableThreadMessageElement.
	aViewModel := self veryLongMessageViewModelQuestion.
	anElement threadMessageViewModel: aViewModel.

	^ anElement
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> veryLongMessageQuestion [
	<gtExample>
	| aJson |
	aJson := self veryLongJsonQuestion.
	^ GtOpenAIThreadMessage from: aJson
]

{ #category : #'examples - messages' }
GtOpenAIExamples >> veryLongMessageViewModelQuestion [
	<gtExample>
	| aViewModel aMessage |
	aViewModel := self basicThreadMessageViewModel.
	aMessage := self veryLongMessageQuestion.
	aViewModel threadMessage: aMessage.

	^ aViewModel
]
