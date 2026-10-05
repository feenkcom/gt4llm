Class {
	#name : #GtLModelExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'Gt4LlmCore-Examples-Model'
}

{ #category : #asserting }
GtLModelExamples class >> compareShapes: actualMessages with: expectedHistory [
	"Assert that the shapes of the user message entities being sent to the LLMs match the expected values."
		| message jsonComparison |

	1 to: actualMessages size do: [ :i | 
		message := actualMessages at: i.
		message isUserMessage ifTrue:
			[ jsonComparison := GtJsonShapeComparison
				compare: (message requestResponse request gtJsonContents)
				with: ((expectedHistory at: i) request gtJsonContents).
			self assert: jsonComparison matches. ] ].
]

{ #category : #asserting }
GtLModelExamples class >> compareShapes: actualMessages with: expectedHistory in: aChat class: aClass selector: selectorSymbol [
	"Assert that the shapes of the user message entities being sent to the LLMs match the expected values. If they differ, signal an error that can update the recorded history from the debugger."
	| message jsonComparison |

	1 to: actualMessages size do: [ :i |
		message := actualMessages at: i.
		message isUserMessage ifTrue: [
			jsonComparison := GtJsonShapeComparison
				compare: message requestResponse request gtJsonContents
				with: (expectedHistory at: i) request gtJsonContents.
			jsonComparison matches ifFalse: [
				^ GtLChatShapeComparisonFailure new
					chat: aChat;
					actualMessages: actualMessages;
					targetClass: aClass;
					targetSelector: selectorSymbol;
					comparison: jsonComparison;
					messageIndex: i;
					signal ] ] ]
]

{ #category : #testing }
GtLModelExamples class >> isAbstract [
	^ self name = #GtLModelExamples
]

{ #category : #private }
GtLModelExamples >> compareIfKnownShapes: actualMessages with: expectedHistory in: aChat selector: selectorSymbol [

	expectedHistory ifNil: [ ^ self ].
	^ self class 
		compareShapes: actualMessages 
		with: expectedHistory
		in: aChat
		class: self class
		selector: selectorSymbol
]

{ #category : #private }
GtLModelExamples >> compareShapes: actualMessages with: expectedHistory [

	^ self class compareShapes: actualMessages with: expectedHistory
]

{ #category : #testing }
GtLModelExamples >> isLive [

	^ self class isLive
]

{ #category : #examples }
GtLModelExamples >> messageWithToolCallThenCompactionExample [
	<gtExample>
	| executor chat |

	executor := self messageWithToolCallThenCompactionExecutor.
	chat := executor chat.
	chat 
		markdownResponse;
		tools: (GtLTools withAll: {GtLMagritteToolForClassLookup new}).
	
	chat sendMarkdown: 'Use tools and give me a description of the class GtLCompactionStrategy'.
	executor waitTimeoutSeconds: 60.
	self assert: chat messages size equals: 2.
	self compareShapes: chat messages with: executor expectedHistory.

	chat compact.
	executor waitTimeoutSeconds: 60.
	self assert: chat messages size equals: 4.
	self compareShapes: chat messages with: executor expectedHistory.
	self assert: chat messages last finalMessage hasCompactionResponse.
	self assert: chat messages last assistantMessage roleLabel = 'compaction'.
	self assert: chat messages last assistantMessage role = 'assistant'.
	self assert: chat provider relevantChatMessages size equals: 3.
	
	^ chat
]

{ #category : #'private - data' }
GtLModelExamples >> messageWithToolCallThenCompactionExampleHistory [

	^ self subclassResponsibility
]

{ #category : #private }
GtLModelExamples >> messageWithToolCallThenCompactionExecutor [

	^ self subclassResponsibility
]

{ #category : #private }
GtLModelExamples >> newChatFromModel: model [
	"Answer a new chat configured and signal the receiver's semaphore when it goes idle."
	| chat |
	
	chat := model provider chat.
	chat
		when: GtLChatExecutionStateChanged
		send: #signalSemaphoreOnFinished:
		to: self.
	^ chat
]
