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
