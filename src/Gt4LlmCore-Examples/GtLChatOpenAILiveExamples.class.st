Class {
	#name : #GtLChatOpenAILiveExamples,
	#superclass : #Object,
	#instVars : [
		'theChat'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLChatOpenAILiveExamples >> createChat [
	<gtExample>
	| newChat provider|
	newChat := GtLChat new.
	
	provider := self createGpt51CodexConnection	buildProvider.
	newChat provider: provider.
	
	^ newChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> createGpt51CodexConnection [
	<gtExample>
	^ GtLConnection new
		providerClass: GtLOpenAIProvider;
		label: 'GPT 5.1 Codex';
		model: 'gpt-5.1-codex';
		addOption: 'isStreaming' withValue: false
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> currentChat [
	<gtExample>
	
	^ theChat ifNil: [
			theChat := self createChat ]
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> howAreYouCallExample [
	<gtExample>
	| responseMessage  |
	responseMessage := self currentChat sendPlainMessage: 'How are you?'.
	
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithToolCallExample [
	<gtExample>
	| messageCall currentMessage responseMessage  |
	messageCall := GtLStringMessageCall new
		string: 'Use tools and give me a description of the class BlElement'.
	
	currentMessage := self currentChat createMessageForCall: messageCall.
	currentMessage tools: (GtLToolsGroup withAll: {GtLlmToolForClassLookup new}).
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 3.
	
	^ self currentChat
]

{ #category : #utils }
GtLChatOpenAILiveExamples >> waitForChatCompletion [
	self currentChat provider executions last wait
]
