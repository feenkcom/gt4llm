"
I am a synchronous stand-in for a Futures future (TAsyncFuture), used in GemStone, where the Futures framework is not available.

In GemStone, BlockClosure>>#asAsyncFuture (a GtGemStoneExtensionMethod on ExecBlock) answers an instance of me. I evaluate my block when I'm sent #await: (or #await), in the calling process, and answer a resolved GtLSynchronousPromise: fulfilled with the block's value, or rejected with the Error it signalled. The execution configuration is ignored.

I cover only the protocol that GtLChat's providers use (see GtLOpenAIProvider>>#executeAsyncMessage:). I'm plain Smalltalk, so my examples (GtLSynchronousFutureExamples) run in both GT and GemStone. In GT I'm not used by the system.
"
Class {
	#name : #GtLSynchronousFuture,
	#superclass : #Object,
	#instVars : [
		'block'
	],
	#category : #'Gt4LlmCore-GemStone'
}

{ #category : #'instance creation' }
GtLSynchronousFuture class >> block: aBlock [
	<return: #GtLSynchronousFuture>
	^ self new setBlock: aBlock
]

{ #category : #converting }
GtLSynchronousFuture >> asAsyncFuture [
	^ self
]

{ #category : #converting }
GtLSynchronousFuture >> asAsyncPromise [
	<return: #GtLSynchronousPromise>
	^ self await
]

{ #category : #'api - future' }
GtLSynchronousFuture >> await [
	<return: #GtLSynchronousPromise>
	^ self await: nil
]

{ #category : #'api - future' }
GtLSynchronousFuture >> await: anExecutionConfiguration [
	"Evaluate my block now, in the calling process, and answer a resolved promise:
	fulfilled with the block's value, or rejected with the Error it signals.
	anExecutionConfiguration (priority, group, ...) is ignored: there is no thread pool."

	<return: #GtLSynchronousPromise>
	^ GtLSynchronousPromise evaluate: block with: nil
]

{ #category : #accessing }
GtLSynchronousFuture >> block [
	^ block
]

{ #category : #private }
GtLSynchronousFuture >> setBlock: aBlock [
	block := aBlock
]
