Class {
	#name : #GtLlmAssistantByScripterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-GToolkit-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmAssistantByScripterExamples >> assistantChat [
	<gtExample>
	| tutor chat |
	tutor := self basicAssistant.
	chat := tutor createChatWithProvider: (GtLlmStaticProvider new
				messages: {'{"Action": "Chat", "Text": "Hello! I am your AI assistant, what can I do for you?"}'};
				userMessageClass: GtLlmActionMessage;
				assistantMessageClass: GtLlmActionMessage).

	self assert: (chat provider isKindOf: GtLlmStaticProvider).
	self assert: chat provider chat equals: chat.
	
	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmAssistantByScripterExamples >> basicAssistant [
	<gtExample>
	| tutor |
	tutor :=  GtLlmAssistant new connection: GtLlmNullConnection new.
	
	self assert: tutor actions size equals: 1.
	self assert: tutor instruction formats size equals: 3.
	
	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmAssistantByScripterExamples >> chatElement [
	<gtExample>
	^ self assistantChat asElement beSync
]

{ #category : #'as yet unclassified' }
GtLlmAssistantByScripterExamples >> chatElementWithMessageSent [
	<gtExample>
	| scripter |
	scripter := self chatElementWithMessageTyped.

	scripter click
		label: 'Click on Send';
		id: #send;
		play.

	self
		assert: scripter element chatViewModel assistantChat messages size
		equals: 2.
	self
		assert: scripter element chatViewModel assistantChat messages first content
		equals: '{"Action":"Chat","Arguments":["Hi!"]}'.
	self
		assert: (scripter element chatViewModel assistantChat messages at: 2) content
		equals: '{"Action": "Chat", "Text": "Hello! I am your AI assistant, what can I do for you?"}'.

	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmAssistantByScripterExamples >> chatElementWithMessageTyped [
	<gtExample>
	| scripter |
	scripter := self scripterOnAssistantChat.

	scripter
		clickStep: [ :s | 
			s
				label: 'Click on Editor';
				id: #contents ].

	scripter
		typeStep: [ :s | 
			s
				label: 'Type message';
				text: 'Hi!' ].


	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmAssistantByScripterExamples >> chatElementWithProviderSelected [
	<gtExample>
	| scripter element |
	scripter := self chatElementWithProviderSelectionOpened.
	element := scripter element.

	scripter
		clickStep: [ :s | 
			s
				label: 'Click on Null Provider';
						onSpaceRoot;
				id: #'provider-list' ].
				
	self assert: (element chatViewModel assistantChat provider isKindOf: GtLlmNullProvider).


	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmAssistantByScripterExamples >> chatElementWithProviderSelectionOpened [
	<gtExample>
	| scripter element |
	scripter := self scripterOnAssistantChat.
	element := scripter element.
	element chatViewModel newThreadMessageViewModel
		connectionRegistry: (GtLlmConnectionRegistry new clearConnections
				addConnection: (GtLlmConnection new
						label: 'Null';
						provider: GtLlmNullProvider)).

	scripter
		clickStep: [ :s | 
			s
				label: 'Click on Dropdown';
				id: #toolbar;
				onChildAt: 3 ].


	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmAssistantByScripterExamples >> scripterOnAssistantChat [
	<gtExample>
	^ BlScripter new element: self assistantChat asElement
]
