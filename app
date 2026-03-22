package com.example.myapplication

import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.database.*

class MainActivity : AppCompatActivity() {

    private lateinit var database: DatabaseReference

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val etId = findViewById<EditText>(R.id.etId)
        val etName = findViewById<EditText>(R.id.etName)
        val etSection = findViewById<EditText>(R.id.etSection)
        val etPhone = findViewById<EditText>(R.id.etPhone)
        val txtResult = findViewById<TextView>(R.id.txtResult)

        val btnAdd = findViewById<Button>(R.id.btnAdd)
        val btnUpdate = findViewById<Button>(R.id.btnUpdate)
        val btnDelete = findViewById<Button>(R.id.btnDelete)
        val btnShow = findViewById<Button>(R.id.btnShow)

        database = FirebaseDatabase.getInstance().reference.child("Students")
        Toast.makeText(
            this,
            FirebaseDatabase.getInstance().reference.root.toString(),
            Toast.LENGTH_LONG
        ).show()

        fun getId(): String {
            val id = etId.text.toString().trim()
            if (id.isEmpty()) {
                toast("Please enter Student ID")
                throw Exception("ID EMPTY")
            }
            return id
        }

        btnAdd.setOnClickListener {
            try {
                val id = getId()
                val data = mapOf(
                    "name" to etName.text.toString(),
                    "section" to etSection.text.toString(),
                    "phone" to etPhone.text.toString()
                )
                database.child(id).setValue(data)
                toast("Student Added")
            } catch (_: Exception) {}
        }

        btnUpdate.setOnClickListener {
            try {
                val id = getId()
                database.child(id).updateChildren(
                    mapOf(
                        "name" to etName.text.toString(),
                        "section" to etSection.text.toString(),
                        "phone" to etPhone.text.toString()
                    )
                )
                toast("Student Updated")
            } catch (_: Exception) {}
        }

        btnDelete.setOnClickListener {
            try {
                val id = getId()
                database.child(id).removeValue()
                toast("Student Deleted")
            } catch (_: Exception) {}
        }

        btnShow.setOnClickListener {
            database.addListenerForSingleValueEvent(object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    val builder = StringBuilder()
                    for (s in snapshot.children) {
                        builder.append("ID: ${s.key}\n")
                        builder.append("Name: ${s.child("name").value}\n")
                        builder.append("Section: ${s.child("section").value}\n")
                        builder.append("Phone: ${s.child("phone").value}\n\n")
                    }
                    txtResult.text = builder.toString()
                }

                override fun onCancelled(error: DatabaseError) {
                    toast("Database Error")
                }
            })
        }
    }

    private fun toast(msg: String) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()
    }
}   


<?xml version="1.0" encoding="utf-8"?>
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#E3F2FD">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="16dp">

        <!-- Title with Icons -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:gravity="center"
            android:background="#1976D2"
            android:padding="12dp">

            <!-- Left Icon -->

            <!-- Title Text -->
            <ImageView
                android:layout_width="63dp"
                android:layout_height="45dp"
                android:layout_marginEnd="8dp"
                android:contentDescription="Left Icon"
                android:src="@drawable/ic_launcher_foreground" />

            <!-- Right Icon -->
            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="Student Records App"
                android:textColor="#FFFFFF"
                android:textSize="22sp"
                android:textStyle="bold" />

            <ImageView
                android:layout_width="43dp"
                android:layout_height="36dp"
                android:layout_marginStart="8dp"
                android:contentDescription="Right Icon"
                android:src="@drawable/x" />
        </LinearLayout>

        <TextView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="Using Firebase Realtime Database"
            android:textColor="#FFFFFF"
            android:background="#2196F3"
            android:gravity="center"
            android:padding="6dp"/>

        <!-- Inputs -->
        <EditText
            android:id="@+id/etId"
            android:hint="Student ID"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:background="#FFFFFF"
            android:padding="10dp"
            android:layout_marginTop="12dp"/>

        <EditText
            android:id="@+id/etName"
            android:hint="Name"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:background="#FFFFFF"
            android:padding="10dp"/>

        <EditText
            android:id="@+id/etSection"
            android:hint="Section"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:background="#FFFFFF"
            android:padding="10dp"/>

        <EditText
            android:id="@+id/etPhone"
            android:hint="Phone Number"
            android:inputType="phone"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:background="#FFFFFF"
            android:padding="10dp"/>

        <!-- Buttons -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:gravity="center"
            android:layout_marginTop="10dp">

            <Button
                android:id="@+id/btnAdd"
                android:text="Add"
                android:backgroundTint="#4CAF50"
                android:textColor="#FFFFFF"
                android:layout_width="0dp"
                android:layout_weight="1"
                android:layout_height="wrap_content"/>

            <Button
                android:id="@+id/btnUpdate"
                android:text="Update"
                android:backgroundTint="#FF9800"
                android:textColor="#FFFFFF"
                android:layout_width="0dp"
                android:layout_weight="1"
                android:layout_height="wrap_content"/>

            <Button
                android:id="@+id/btnDelete"
                android:text="Delete"
                android:backgroundTint="#F44336"
                android:textColor="#FFFFFF"
                android:layout_width="0dp"
                android:layout_weight="1"
                android:layout_height="wrap_content"/>

            <Button
                android:id="@+id/btnShow"
                android:text="Show"
                android:backgroundTint="#2196F3"
                android:textColor="#FFFFFF"
                android:layout_width="0dp"
                android:layout_weight="1"
                android:layout_height="wrap_content"/>
        </LinearLayout>

        <!-- Output -->
        <TextView
            android:id="@+id/txtResult"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="Student List"
            android:textSize="16sp"
            android:textStyle="bold"
            android:textColor="#000000"
            android:layout_marginTop="14dp"
            android:padding="8dp"
            android:background="#FFFFFF"/>
    </LinearLayout>
</ScrollView>
