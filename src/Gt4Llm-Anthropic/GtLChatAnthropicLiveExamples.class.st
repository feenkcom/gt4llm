Class {
	#name : #GtLChatAnthropicLiveExamples,
	#superclass : #GtLChatLiveExamples,
	#category : 'Gt4Llm-Anthropic-Examples'
}

{ #category : #'examples - basic' }
GtLChatAnthropicLiveExamples >> createClauseOpus46Connection [
	<gtExample>
	<noTest>
	^ GtLConnection new
			providerClass: GtLAnthropicProvider;
			label: 'Claude Opus 4.6';
			model: 'claude-opus-4-6'
]

{ #category : #'examples - basic' }
GtLChatAnthropicLiveExamples >> createProvider [
	<gtExample>
	| aProvider |
	
	aProvider := self isLive 
		ifTrue: [self createClauseOpus46Connection buildProvider] 
		ifFalse: [self createClauseOpus46Connection buildBareProvider].

	"self isLive
		ifFalse: [ aProvider client clientBuilder: GtLOpenAIClientStubBuilder new ]."

	^ aProvider
]

{ #category : #'examples - calls' }
GtLChatAnthropicLiveExamples >> howAreYouCallExample [
	"Ready for stub execution"
	<gtExample>
	<noTest>
	
	^ super howAreYouCallExample
]

{ #category : #examples }
GtLChatAnthropicLiveExamples >> howAreYouCallExample_withStringSchema [
	"Ready for stub execution"
	<gtExample>
	<noTest>
	
	^ super howAreYouCallExample_withStringSchema
]

{ #category : #examples }
GtLChatAnthropicLiveExamples >> messageWithToolCallExample [
	"Ready for stub execution"
	<gtExample>
	<noTest>
	
	^ super messageWithToolCallExample
]

{ #category : #examples }
GtLChatAnthropicLiveExamples >> messageWithToolCallExample_magritteMarkdown [
	"Ready for stub execution"
	<gtExample>
	<noTest>
	
	^ super messageWithToolCallExample_magritteMarkdown
]
