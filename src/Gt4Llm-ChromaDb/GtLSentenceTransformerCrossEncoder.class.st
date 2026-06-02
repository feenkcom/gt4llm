Class {
	#name : #GtLSentenceTransformerCrossEncoder,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'pbApplication'
	],
	#category : #'Gt4Llm-ChromaDb'
}

{ #category : #accessing }
GtLSentenceTransformerCrossEncoder class >> default [
	^ self uniqueInstance start
]

{ #category : #'initialize-release' }
GtLSentenceTransformerCrossEncoder class >> initialize [

	SessionManager default registerUserClassNamed: self name.
]

{ #category : #'startup - shutdown' }
GtLSentenceTransformerCrossEncoder class >> shutDown: isQuitting [

	self hasUniqueInstance ifTrue:
		[ self uniqueInstance stop ]
]

{ #category : #'start-stop' }
GtLSentenceTransformerCrossEncoder >> immportSentenceTransformer [

	pbApplication newCommandStringFactory
		script:
'from sentence_transformers import CrossEncoder
import json';
		resultExpression: 'None';
		send.
]

{ #category : #installation }
GtLSentenceTransformerCrossEncoder >> installSentenceTransformers [

	pbApplication installModule: 'sentence_transformers'
]

{ #category : #api }
GtLSentenceTransformerCrossEncoder >> reRankQuery: queryString documents: documents [
	"Re-rank the supplied documents (array of strings)"
	| pythonScript commandFactory resultString |

	pythonScript :=
'cross_encoder = CrossEncoder("cross-encoder/ms-marco-MiniLM-L6-v2")
ranks = cross_encoder.rank(query, documents)
results = [[int(item[''corpus_id'']), float(item[''score''])] for item in ranks]
'.
	commandFactory := pbApplication newCommandStringFactory.
	resultString := commandFactory
		bindingAt: #query put: queryString asString;
		bindingAt: #documents put: documents asArray;
		script: pythonScript;
		resultExpression: 'json.dumps(results)';
		sendAndWait.
	^ (NeoJSONReader on: resultString readStream) next
]

{ #category : #'start-stop' }
GtLSentenceTransformerCrossEncoder >> start [

	(pbApplication isNotNil and: [ pbApplication isRunning ]) ifTrue: [ ^ self ].
	pbApplication := PBApplication new.
	pbApplication start.
	self immportSentenceTransformer
]

{ #category : #'start-stop' }
GtLSentenceTransformerCrossEncoder >> stop [

	pbApplication stop
]
