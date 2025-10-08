Class {
	#name : #GtLlmLeSnippetVisitor,
	#superclass : #Object,
	#instVars : [
		'stack'
	],
	#category : #'Gt4Llm-Lepiter-Model'
}

{ #category : #initialization }
GtLlmLeSnippetVisitor >> initialize [

	super initialize.
	stack := Stack new.
]

{ #category : #visiting }
GtLlmLeSnippetVisitor >> visitGtLlmBasicChatMessage: aGtLlmChatMessage [
	"nothing"
]

{ #category : #visiting }
GtLlmLeSnippetVisitor >> visitGtLlmChat: aGtLlmChat [
	| snippet |

	snippet := LeLlmChatSnippet new 
		chat: aGtLlmChat.
	stack push: snippet.
	aGtLlmChat messages acceptVisitor: self.
	stack pop.
	^ snippet
]

{ #category : #visiting }
GtLlmLeSnippetVisitor >> visitGtLlmChatMessage: aGtLlmChatMessage [
	| snippet |

	snippet := LeLlmChatMessageSnippet new
		messageId: aGtLlmChatMessage id.
	^ snippet
]

{ #category : #visiting }
GtLlmLeSnippetVisitor >> visitGtLlmMessagesGroup: aGtLlmMessagesGroup [

	aGtLlmMessagesGroup items do: [ :message |
		stack top addSnippet: (message acceptVisitor: self) ]
]

{ #category : #visiting }
GtLlmLeSnippetVisitor >> visitNode: aGtLlmChat [

	^ aGtLlmChat acceptVisitor: self
]
