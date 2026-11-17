"
Examples for GtLSynchronousFuture and GtLSynchronousPromise, the synchronous Futures stand-in used in GemStone. They use the shim classes directly, so they pass in both GT and GemStone.
"
Class {
	#name : #GtLSynchronousFutureExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-GemStone'
}

{ #category : #'examples - chaining' }
GtLSynchronousFutureExamples >> errorInThenBlockRejectsWithoutCallingOtherwise [
	"As in AsyncFulfilledPromise>>#then:otherwise:, the otherwise block only handles the receiver's rejection, not an error in the then block."

	<gtExample>
	<return: #GtLSynchronousPromise>
	| otherwiseCalled promise |
	otherwiseCalled := false.
	promise := self futureEvaluatesOnlyOnAwait
			then: [ :aValue | aValue / 0 ]
			otherwise: [ :anError | 
				otherwiseCalled := true.
				0 ].
	self assert: otherwiseCalled not.
	self assert: promise isRejected.
	self assert: (promise error isKindOf: ZeroDivide).
	^ promise
]

{ #category : #'examples - future' }
GtLSynchronousFutureExamples >> futureEvaluatesOnlyOnAwait [
	<gtExample>
	<return: #GtLSynchronousPromise>
	| count future promise |
	count := 0.
	future := GtLSynchronousFuture
			block: [ count := count + 1.
				3 + 4 ].
	self assert: count equals: 0.

	promise := future await: nil.
	self assert: count equals: 1.
	self assert: promise isFulfilled.
	self assert: promise isRejected not.
	self assert: promise value equals: 7.
	self assert: promise error isNil.
	^ promise
]

{ #category : #'examples - future' }
GtLSynchronousFutureExamples >> futureIgnoresExecutionConfiguration [
	"The configuration GtLChat's providers pass (see GtLOpenAISettings class>>#futureExecutionConfiguration) is accepted and ignored.
	In GemStone this also exercises the no-op AsyncFutureExecutionConfiguration extension methods."

	<gtExample>
	<return: #GtLSynchronousPromise>
	| configuration promise |
	configuration := AsyncFutureExecutionConfiguration new
			customGroup: #GtLSynchronousFutureExamples;
			lowPriority.
	promise := (GtLSynchronousFuture block: [ #done ]) await: configuration.
	self assert: promise value equals: #done.
	self assert: (GtLSynchronousFuture block: [ #done ]) await value equals: #done.
	self
		assert: (GtLSynchronousFuture block: [ #done ]) asAsyncPromise value
		equals: #done.
	^ promise
]

{ #category : #'examples - future' }
GtLSynchronousFutureExamples >> futureWithErrorIsRejected [
	<gtExample>
	<return: #GtLSynchronousPromise>
	| promise |
	promise := (GtLSynchronousFuture block: [ 1 / 0 ]) await: nil.
	self assert: promise isRejected.
	self assert: promise isFulfilled not.
	self assert: (promise error isKindOf: ZeroDivide).
	self assert: promise value isNil.
	^ promise
]

{ #category : #'examples - chaining' }
GtLSynchronousFutureExamples >> thenAndOtherwisePassThrough [
	<gtExample>
	<return: #GtLSynchronousPromise>
	| fulfilled rejected |
	fulfilled := self futureEvaluatesOnlyOnAwait.
	rejected := self futureWithErrorIsRejected.

	self assert: (fulfilled otherwise: [ :anError | 0 ]) == fulfilled.
	self assert: (rejected then: [ :aValue | 0 ]) == rejected.
	self assert: (fulfilled then: [ :aValue | aValue + 1 ]) value equals: 8.
	self
		assert: (rejected otherwise: [ :anError | #recovered ]) value
		equals: #recovered.
	^ fulfilled then: [ #zeroArgumentBlock ]
]

{ #category : #'examples - chaining' }
GtLSynchronousFutureExamples >> thenOtherwiseOnFulfilledPromise [
	<gtExample>
	<return: #GtLSynchronousPromise>
	| otherwiseCalled promise |
	otherwiseCalled := false.
	promise := self futureEvaluatesOnlyOnAwait
			then: [ :aValue | aValue * 2 ]
			otherwise: [ :anError | 
				otherwiseCalled := true.
				0 ].
	self assert: otherwiseCalled not.
	self assert: promise isFulfilled.
	self assert: promise value equals: 14.
	^ promise
]

{ #category : #'examples - chaining' }
GtLSynchronousFutureExamples >> thenOtherwiseOnRejectedPromiseRecovers [
	<gtExample>
	<return: #GtLSynchronousPromise>
	| thenCalled rejectedError promise |
	thenCalled := false.
	promise := self futureWithErrorIsRejected
			then: [ :aValue | 
				thenCalled := true.
				aValue ]
			otherwise: [ :anError | 
				rejectedError := anError.
				#recovered ].
	self assert: thenCalled not.
	self assert: (rejectedError isKindOf: ZeroDivide).
	self assert: promise isFulfilled.
	self assert: promise value equals: #recovered.
	^ promise
]

{ #category : #'examples - chaining' }
GtLSynchronousFutureExamples >> waitAnswersValueOrError [
	"As TAsyncPromise>>#wait does, a rejected promise answers its error rather than signalling it"

	<gtExample>
	<return: #GtLSynchronousPromise>
	| fulfilled rejected |
	fulfilled := self futureEvaluatesOnlyOnAwait.
	rejected := self futureWithErrorIsRejected.
	self assert: fulfilled wait equals: 7.
	self assert: (rejected wait isKindOf: ZeroDivide).
	^ rejected
]
