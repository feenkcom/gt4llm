"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPRequest,
	#superclass : #GtLACPObject,
	#instVars : [
		'id',
		'method',
		'parameters',
		'state',
		'result',
		'error',
		'semaphore',
		'onSuccess',
		'onFailure'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #serialization }
GtLACPRequest >> asDictionary [
 ^ { 'jsonrpc' -> '2.0'. 'id' -> id. 'method' -> method. 'params' -> parameters } asDictionary
]

{ #category : #lifecycle }
GtLACPRequest >> complete: anObject [
 state = #pending ifFalse: [ ^ self ].
 result := anObject.
 state := #completed.
 [ onSuccess value: result ] ensure: [ semaphore signal ]
]

{ #category : #accessing }
GtLACPRequest >> error [
 ^ error
]

{ #category : #lifecycle }
GtLACPRequest >> fail: anObject [
 state = #pending ifFalse: [ ^ self ].
 error := anObject.
 state := #failed.
 [ onFailure value: error ] ensure: [ semaphore signal ]
]

{ #category : #views }
GtLACPRequest >> gtFailureFor: aView [
 <gtView>
 error ifNil: [ ^ aView empty ].
 ^ aView textEditor title: 'Failure'; priority: 1;
  text: [ error printString ]
]

{ #category : #views }
GtLACPRequest >> gtRequestFor: aView [
 <gtView>
 ^ aView textEditor title: 'Request'; priority: 0;
  text: [ STONJSON toStringPretty: self asDictionary ]
]

{ #category : #views }
GtLACPRequest >> gtResultFor: aView [
 <gtView>
 ^ aView textEditor title: 'Result'; priority: 5;
  text: [ state = #pending
   ifTrue: [ 'Waiting for the agent response' ]
   ifFalse: [ STONJSON toStringPretty: result ] ];
  actionUpdateButtonTooltip: 'Refresh request result'
]

{ #category : #accessing }
GtLACPRequest >> id [
 ^ id
]

{ #category : #accessing }
GtLACPRequest >> id: anObject [
 id := anObject
]

{ #category : #accessing }
GtLACPRequest >> initialize [
 super initialize.
 state := #pending.
 semaphore := Semaphore new.
 onSuccess := [ :value | ].
 onFailure := [ :value | ]
]

{ #category : #accessing }
GtLACPRequest >> method [
 ^ method
]

{ #category : #accessing }
GtLACPRequest >> method: anObject [
 method := anObject
]

{ #category : #accessing }
GtLACPRequest >> onFailure [
 ^ onFailure
]

{ #category : #accessing }
GtLACPRequest >> onFailure: anObject [
 onFailure := anObject
]

{ #category : #accessing }
GtLACPRequest >> onSuccess [
 ^ onSuccess
]

{ #category : #accessing }
GtLACPRequest >> onSuccess: anObject [
 onSuccess := anObject
]

{ #category : #accessing }
GtLACPRequest >> parameters [
 ^ parameters
]

{ #category : #accessing }
GtLACPRequest >> parameters: anObject [
 parameters := anObject
]

{ #category : #accessing }
GtLACPRequest >> result [
 ^ result
]

{ #category : #accessing }
GtLACPRequest >> result: anObject [
 result := anObject
]

{ #category : #accessing }
GtLACPRequest >> semaphore [
 ^ semaphore
]

{ #category : #accessing }
GtLACPRequest >> semaphore: anObject [
 semaphore := anObject
]

{ #category : #accessing }
GtLACPRequest >> state [
 ^ state
]

{ #category : #accessing }
GtLACPRequest >> state: anObject [
 state := anObject
]

{ #category : #waiting }
GtLACPRequest >> waitForSeconds: seconds [
 state = #pending ifTrue: [
  (semaphore waitTimeoutMilliseconds: (seconds * 1000) ceiling) ifTrue: [
   self error: 'Timed out waiting for ACP request: ', method ] ].
 error ifNotNil: [ self error: error printString ].
 ^ result
]
