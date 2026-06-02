"
I provide examples for GtChromaDbIdentity.
"
Class {
	#name : #GtChromaDbObjectExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ChromaDb-Examples'
}

{ #category : #examples }
GtChromaDbObjectExamples >> collection [
	<gtExample>
	| collection configuration schema vectorConfig |
	collection := GtChromaDbCollection new.
	configuration := Dictionary new.
	configuration
		at: 'hnsw' put: (Dictionary new
			at: 'space' put: 'l2';
			at: 'ef_construction' put: 100;
			at: 'ef_search' put: 100;
			at: 'max_neighbors' put: 16;
			at: 'resize_factor' put: 1.2;
			at: 'sync_threshold' put: 1000;
			yourself);
		at: 'spann' put: nil;
		at: 'embedding_function' put: (Dictionary new
			at: 'type' put: 'known';
			at: 'name' put: 'default';
			at: 'config' put: Dictionary new;
			yourself).
	vectorConfig := Dictionary new.
	vectorConfig
		at: 'space' put: 'l2';
		at: 'embedding_function' put: (Dictionary new
			at: 'type' put: 'known';
			at: 'name' put: 'default';
			at: 'config' put: Dictionary new;
			yourself);
		at: 'hnsw' put: (Dictionary new
			at: 'ef_construction' put: 100;
			at: 'max_neighbors' put: 16;
			at: 'ef_search' put: 100;
			at: 'num_threads' put: 32;
			at: 'batch_size' put: 100;
			at: 'sync_threshold' put: 1000;
			at: 'resize_factor' put: 1.2;
			yourself).
	schema := Dictionary new.
	schema
		at: 'defaults' put: (Dictionary new
			at: 'string' put: (Dictionary new
				at: 'fts_index' put: (Dictionary new at: 'enabled' put: false; at: 'config' put: Dictionary new; yourself);
				at: 'string_inverted_index' put: (Dictionary new at: 'enabled' put: true; at: 'config' put: Dictionary new; yourself);
				yourself);
			at: 'float_list' put: (Dictionary new
				at: 'vector_index' put: (Dictionary new at: 'enabled' put: false; at: 'config' put: vectorConfig copy; yourself);
				yourself);
			at: 'sparse_vector' put: (Dictionary new
				at: 'sparse_vector_index' put: (Dictionary new
					at: 'enabled' put: false;
					at: 'config' put: (Dictionary new
						at: 'embedding_function' put: (Dictionary new at: 'type' put: 'unknown'; yourself);
						at: 'bm25' put: false;
						yourself);
					yourself);
				yourself);
			at: 'int' put: (Dictionary new at: 'int_inverted_index' put: (Dictionary new at: 'enabled' put: true; at: 'config' put: Dictionary new; yourself); yourself);
			at: 'float' put: (Dictionary new at: 'float_inverted_index' put: (Dictionary new at: 'enabled' put: true; at: 'config' put: Dictionary new; yourself); yourself);
			at: 'bool' put: (Dictionary new at: 'bool_inverted_index' put: (Dictionary new at: 'enabled' put: true; at: 'config' put: Dictionary new; yourself); yourself);
			yourself);
		at: 'keys' put: (Dictionary new
			at: '#document' put: (Dictionary new
				at: 'string' put: (Dictionary new
					at: 'fts_index' put: (Dictionary new at: 'enabled' put: true; at: 'config' put: Dictionary new; yourself);
					at: 'string_inverted_index' put: (Dictionary new at: 'enabled' put: false; at: 'config' put: Dictionary new; yourself);
					yourself);
				yourself);
			at: '#embedding' put: (Dictionary new
				at: 'float_list' put: (Dictionary new
					at: 'vector_index' put: (Dictionary new
						at: 'enabled' put: true;
						at: 'config' put: (vectorConfig copy at: 'source_key' put: '#document'; yourself);
						yourself);
					yourself);
				yourself);
			yourself).
	collection rawData: (Dictionary new
		at: 'id' put: '24849b30-fdd4-4bed-84e3-dffc9eb6cc5b';
		at: 'name' put: 'vehichles';
		at: 'configuration_json' put: configuration;
		at: 'schema' put: schema;
		at: 'metadata' put: nil;
		at: 'dimension' put: 384;
		at: 'tenant' put: 'default_tenant';
		at: 'database' put: 'default_database';
		at: 'log_position' put: 0;
		at: 'version' put: 0;
		yourself).
	self assert: collection id equals: '24849b30-fdd4-4bed-84e3-dffc9eb6cc5b'.
	self assert: collection name equals: 'vehichles'.
	self assert: collection configurationJson hnsw space equals: 'l2'.
	self assert: collection configurationJson embeddingFunction name equals: 'default'.
	self assert: collection schema defaults string ftsIndex enabled equals: false.
	self assert: collection schema defaults floatList vectorIndex config hnsw maxNeighbors equals: 16.
	self assert: collection schema keys document string ftsIndex enabled equals: true.
	self assert: collection schema keys embedding floatList vectorIndex config sourceKey equals: '#document'.
	self assert: collection metadata equals: nil.
	self assert: collection dimension equals: 384.
	self assert: collection tenant equals: 'default_tenant'.
	self assert: collection database equals: 'default_database'.
	self assert: collection logPosition equals: 0.
	self assert: collection version equals: 0.
	^ collection
]

{ #category : #examples }
GtChromaDbObjectExamples >> database [
	<gtExample>
	| database |
	database := GtChromaDbDatabase new.
	database rawData: ((NeoJSONObject fromString: '[{"id":"00000000-0000-0000-0000-000000000000","name":"default_database","tenant":"default_tenant"}]') first).
	self assert: database id equals: '00000000-0000-0000-0000-000000000000'.
	self assert: database name equals: 'default_database'.
	self assert: database tenant equals: 'default_tenant'.
	^ database
]

{ #category : #examples }
GtChromaDbObjectExamples >> identity [
	<gtExample>
	| identity |
	identity := GtChromaDbIdentity new.
	identity rawData: {
		'user_id' -> ''.
		'databases' -> #('default_database').
		'tenant' -> 'default_tenant' } asDictionary.
	self assert: identity userId equals: ''.
	self assert: identity databases equals: #('default_database').
	self assert: identity tenant equals: 'default_tenant'.
	^ identity
]
