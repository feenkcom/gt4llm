Class {
	#name : #LeLlmChatSnippet,
	#superclass : #LeLlmSnippet,
	#instVars : [
		'chat'
	],
	#category : #'Gt4Llm-Lepiter-Model'
}

{ #category : #accessing }
LeLlmChatSnippet class >> empty [

	^ self new
]

{ #category : #accessing }
LeLlmChatSnippet class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: (#chat -> #chat);
		yourself
]

{ #category : #accessing }
LeLlmChatSnippet class >> leJsonV4Name [

	^ #llmChatSnippet
]

{ #category : #converting }
LeLlmChatSnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>

	^ LeTextCoderSnippetViewModel new snippetModel: self
]

{ #category : #accessing }
LeLlmChatSnippet >> chat [
	^ chat
]

{ #category : #accessing }
LeLlmChatSnippet >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
LeLlmChatSnippet >> contentAsString [

	^ String streamContents: [ :stream |
		stream
			<< 'LLM Chat'; cr;
			<< '========'; cr;
			cr;
			<< 'Last Updated: ';
				print: chat lastUpdate; cr;
			<< 'Provider: ';
				print: chat provider; cr. ]
]

{ #category : #ui }
LeLlmChatSnippet >> copySerialisationToClipboard [
	| serialization |

	serialization := LeJsonV4 uniqueInstance serialize: self.
	Clipboard default clipboardText: serialization.
]

{ #category : #accessing }
LeLlmChatSnippet >> entityWithId: aUUID [
	"Answer the receiver's entity with the supplied UUID.
	This should delegate to the chat to handle arbitrary nesting.
	For now, search the group's items directly."

	^ self chat messages items detect: [ :each |
		each id = aUUID ]
]

{ #category : #accessing }
LeLlmChatSnippet >> group [

	^ chat messages
]

{ #category : #accessing }
LeLlmChatSnippet >> text [

	^ self contentAsString asRopedText
]
