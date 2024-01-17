// Copyright 2022-2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package testutils

var (
	RetryableTransientErrors = map[string]string{
		// Error code 409 for concurrent policy changes.
		".*Error 409.*There were concurrent policy changes.*": "Concurrent policy changes.",

		// Error 403 for quota exceeded
		".*Error 403.*Quota exceeded for quota metric.*": "Quota exceeded.",
	}
)
