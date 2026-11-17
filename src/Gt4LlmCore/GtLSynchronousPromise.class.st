"
I am an already-resolved promise, answered by GtLSynchronousFuture>>#await:. I am either fulfilled with a value or rejected with an error.

Chaining follows GT's AsyncFulfilledPromise / AsyncRejectedPromise:
- #then:otherwise: on a fulfilled promise evaluates only the fulfilment block. On a rejected promise it evaluates only the rejection block, whose value fulfils the answered promise (recovery).
- An Error signalled by either block answers a rejected promise; it is not passed on to the other block.
- Blocks are evaluated with #cull:, so zero-argument blocks are accepted.

Unlike GT, a block that answers a promise is not flattened; the promise becomes the value.
"
Class {
	#name : #GtLSynchronousPromise,
	#superclass : #Object,
	#instVars : [
		'value',
		'error',
		'isRejected'
	],
	#category : #'Gt4LlmCore-GemStone'
}

{ #category : #'instance creation' }
GtLSynchronousPromise class >> evaluate: aBlock with: anObject [
	"Evaluate aBlock with anObject (#cull:, so zero-argument blocks are accepted) and answer a promise fulfilled with its value, or rejected with the Error it signals."

	<return: #GtLSynchronousPromise>
	^ [ self fulfilledWith: (aBlock cull: anObject) ]
		on: Error
		do: [ :anError | self rejectedWith: anError ]
]

{ #category : #'instance creation' }
GtLSynchronousPromise class >> fulfilledWith: anObject [
	<return: #GtLSynchronousPromise>
	^ self new setValue: anObject
]

{ #category : #'instance creation' }
GtLSynchronousPromise class >> rejectedWith: anError [
	<return: #GtLSynchronousPromise>
	^ self new setError: anError
]

{ #category : #accessing }
GtLSynchronousPromise >> error [
	"Answer the rejection error, or nil if I am fulfilled"

	^ error
]

{ #category : #testing }
GtLSynchronousPromise >> isAsyncPromise [
	^ true
]

{ #category : #testing }
GtLSynchronousPromise >> isFulfilled [
	^ isRejected not
]

{ #category : #testing }
GtLSynchronousPromise >> isRejected [
	^ isRejected
]

{ #category : #chaining }
GtLSynchronousPromise >> otherwise: onRejectedBlock [
	"Answer a promise for the value of onRejectedBlock (recovery), or myself if I am fulfilled"

	<return: #GtLSynchronousPromise>
	^ isRejected
		ifTrue: [ self class evaluate: onRejectedBlock with: error ]
		ifFalse: [ self ]
]

{ #category : #printing }
GtLSynchronousPromise >> printOn: aStream [
	super printOn: aStream.
	isRejected ifNil: [ ^ self ].
	aStream
		nextPutAll: (isRejected ifTrue: [ ' (rejected: ' ] ifFalse: [ ' (fulfilled: ' ]).
	(isRejected ifTrue: [ error ] ifFalse: [ value ]) printOn: aStream.
	aStream nextPut: $)
]

{ #category : #private }
GtLSynchronousPromise >> setError: anError [
	value := nil.
	error := anError.
	isRejected := true
]

{ #category : #private }
GtLSynchronousPromise >> setValue: anObject [
	value := anObject.
	error := nil.
	isRejected := false
]

{ #category : #chaining }
GtLSynchronousPromise >> then: onFulfilledBlock [
	"Answer a promise for the value of onFulfilledBlock, or myself if I am rejected"

	<return: #GtLSynchronousPromise>
	^ isRejected
		ifTrue: [ self ]
		ifFalse: [ self class evaluate: onFulfilledBlock with: value ]
]

{ #category : #chaining }
GtLSynchronousPromise >> then: onFulfilledBlock otherwise: onRejectedBlock [
	"Evaluate only the block matching my state, as AsyncFulfilledPromise and AsyncRejectedPromise do.
	An Error signalled by the block answers a rejected promise; it is not passed on to the other block."

	<return: #GtLSynchronousPromise>
	^ isRejected
		ifTrue: [ self class evaluate: onRejectedBlock with: error ]
		ifFalse: [ self class evaluate: onFulfilledBlock with: value ]
]

{ #category : #accessing }
GtLSynchronousPromise >> value [
	"Answer the fulfilment value, or nil if I am rejected"

	^ value
]

{ #category : #accessing }
GtLSynchronousPromise >> wait [
	"Answer my value, or my error if I am rejected (as TAsyncPromise>>#wait does; the error is answered, not signalled).
	I am already resolved, so I never block."

	^ isRejected ifTrue: [ error ] ifFalse: [ value ]
]
