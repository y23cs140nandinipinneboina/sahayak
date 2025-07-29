/*
  # Complete fix for teacher signup process

  1. Security Updates
    - Ensure proper RLS policies for teachers table
    - Fix any issues with user creation and profile insertion
    - Add proper policies for all operations

  2. Changes
    - Drop and recreate all teachers table policies
    - Ensure auth.uid() is properly accessible
    - Add comprehensive policies for CRUD operations
*/

-- First, let's drop all existing policies on teachers table
DROP POLICY IF EXISTS "Users can create own teacher profile" ON teachers;
DROP POLICY IF EXISTS "Teachers can insert own profile" ON teachers;
DROP POLICY IF EXISTS "Teachers can read own profile" ON teachers;
DROP POLICY IF EXISTS "Teachers can read profiles" ON teachers;
DROP POLICY IF EXISTS "Teachers can update own profile" ON teachers;
DROP POLICY IF EXISTS "Users can create own teacher profile" ON teachers;

-- Create comprehensive policies for teachers table

-- Allow authenticated users to insert their own teacher profile
CREATE POLICY "Users can create own teacher profile"
  ON teachers
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Allow users to read their own profile
CREATE POLICY "Teachers can read own profile"
  ON teachers
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

-- Allow users to update their own profile
CREATE POLICY "Teachers can update own profile"
  ON teachers
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow users to delete their own profile (optional, but good to have)
CREATE POLICY "Teachers can delete own profile"
  ON teachers
  FOR DELETE
  TO authenticated
  USING (auth.uid() = id);

-- Ensure RLS is enabled on teachers table
ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;

-- Grant necessary permissions to authenticated users
GRANT SELECT, INSERT, UPDATE, DELETE ON teachers TO authenticated;
GRANT USAGE ON SCHEMA public TO authenticated;