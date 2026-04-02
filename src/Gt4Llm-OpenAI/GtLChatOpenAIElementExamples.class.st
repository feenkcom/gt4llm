Class {
	#name : #GtLChatOpenAIElementExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-OpenAI-Examples'
}

{ #category : #examples }
GtLChatOpenAIElementExamples >> actionToolbarMessageElement [
	<gtExample>
	<return: #GtLActionToolbarMessageElement>
	| aChat aMessage aViewModel anElement |
	aChat := self howAreYouChat.
	aMessage := aChat messages last.
	aViewModel := GtLReplyMessageViewModel new
		message: aMessage;
		yourself.
	anElement := GtLActionToolbarMessageElement new
		messageViewModel: aViewModel;
		yourself.
	self assert: anElement class equals: GtLActionToolbarMessageElement.
	^ anElement
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> chatWithSeveralToolCalls [
	<gtExample>
	<return: #GtLChat>
	^ GtLChatOpenAILiveExamples new chatWithSeveralToolCalls
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> chatWithTwoBasicMessages [
	<gtExample>
	<return: #GtLChat>
	^ GtLChatOpenAILiveExamples new chatWithTwoBasicMessages
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> howAreYouChat [
	<gtExample>
	<return: #GtLChat>
	^ GtLChatOpenAILiveExamples new howAreYouCallExample
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> messageHeaderElement [
	<gtExample>
	<return: #GtLMessageHeaderElement>
	| aChat aMessage aViewModel anElement |
	aChat := self howAreYouChat.
	aMessage := aChat messages last.
	aViewModel := GtLReplyMessageViewModel new
		message: aMessage;
		yourself.
	anElement := aViewModel messageHeaderElement.
	self assert: anElement class equals: GtLMessageHeaderElement.
	^ anElement
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> messageOneLineMultiLabelSummaryElement [
	<gtExample>
	<return: #GtMessageOneLineMultiLabelSummaryElement>
	| aChat aMessage aViewModel anElement |
	aChat := self chatWithSeveralToolCalls.
	aMessage := aChat messages last.
	aViewModel := GtLReplyMessageViewModel new
		message: aMessage;
		yourself.
	anElement := GtMessageOneLineMultiLabelSummaryElement new
		messageViewModel: aViewModel;
		yourself.
	^ anElement
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> messageOneLineOneLabelSummaryElement [
	<gtExample>
	<return: #GtMessageOneLineOneLabelSummaryElement>
	| aChat aMessage aViewModel anElement |
	aChat := self howAreYouChat.
	aMessage := aChat messages last.
	aViewModel := GtLReplyMessageViewModel new
		message: aMessage;
		yourself.
	anElement := GtMessageOneLineOneLabelSummaryElement new
		messageViewModel: aViewModel;
		text: aViewModel contentOneLineSummary;
		yourself.
	^ anElement
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> messageSenderAndDateHeaderElement [
	<gtExample>
	<return: #GtLMessageSenderAndDateHeaderElement>
	| aChat aMessage aViewModel anElement |
	aChat := self howAreYouChat.
	aMessage := aChat messages last.
	aViewModel := GtLReplyMessageViewModel new
		message: aMessage;
		yourself.
	anElement := GtLMessageSenderAndDateHeaderElement new
		messageViewModel: aViewModel;
		yourself.
	self assert: anElement class equals: GtLMessageSenderAndDateHeaderElement.
	^ anElement
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> messageUsedToolsElement [
	<gtExample>
	<return: #GtLMessageUsedToolsElement>
	| aChat aMessage aViewModel anElement |
	aChat := self chatWithSeveralToolCalls.
	aMessage := aChat messages last.
	aViewModel := GtLReplyMessageViewModel new
		message: aMessage;
		yourself.
	anElement := GtLMessageUsedToolsElement new
		messageViewModel: aViewModel;
		yourself.
	self assert: anElement class equals: GtLMessageUsedToolsElement.
	^ anElement
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> messageViewsElement [
	<gtExample>
	<return: #GtLMessageViewsElement>
	| aChat aMessage aViewModel anElement |
	aChat := self howAreYouChat.
	aMessage := aChat messages last.
	aViewModel := GtLReplyMessageViewModel new
		message: aMessage;
		yourself.
	anElement := GtLMessageViewsElement new
		messageViewModel: aViewModel;
		yourself.
	self assert: anElement class equals: GtLMessageViewsElement.
	^ anElement
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> messageWithMagritteToolCall [
	<gtExample>
	<return: #GtLChatMessage>
	^ GtLChatOpenAILiveExamples new messageWithToolCallExample_magritteMarkdown
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> messageWithToolCall [
	<gtExample>
	<return: #GtLChat>
	^ GtLChatOpenAILiveExamples new messageWithToolCallExample
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> replyMessageElement [
	<gtExample>
	<return: #GtLReplyMessageContentElement>
	| aChat aMessage aViewModel anElement |
	aChat := self chatWithSeveralToolCalls.
	aMessage := aChat messages last.
	aViewModel := GtLReplyMessageViewModel new
		message: aMessage;
		yourself.
	anElement := aViewModel elementClass new
		messageViewModel: aViewModel;
		yourself.
	self assert: anElement class equals: GtLReplyMessageContentElement.
	^ anElement
]

{ #category : #examples }
GtLChatOpenAIElementExamples >> userMessageElement [
	<gtExample>
	<return: #GtLUserMessageContentElement>
	| aChat aMessage aViewModel anElement |
	aChat := self chatWithTwoBasicMessages.
	aMessage := aChat messages first.
	aViewModel := GtLMessageViewModel new
		message: aMessage;
		yourself.
	anElement := aViewModel elementClass new
		messageViewModel: aViewModel;
		yourself.
	self assert: anElement class equals: GtLUserMessageContentElement.
	^ anElement
]
